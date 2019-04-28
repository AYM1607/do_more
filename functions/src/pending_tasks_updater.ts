import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { DocumentSnapshot } from 'firebase-functions/lib/providers/firestore';

type DocumentReference = admin.firestore.DocumentReference;
type FieldValue = admin.firestore.FieldValue;

admin.initializeApp();


const incrementValue = admin.firestore.FieldValue.increment(1);
const decrementValue = admin.firestore.FieldValue.increment(-1);
const db = admin.firestore();

/// Gets the user [DocumentReference] for the current task.
const getUserReference = async (taskSnapShot: DocumentSnapshot) => {
    const querySnapshot = await db.collection('users').where('username', '==', taskSnapShot.get('ownerUsername')).get()
    return querySnapshot.docs[0].ref;
}

/// Gets an event document reference for the current task.
const getEventReference = async (
    taskSnapshot: DocumentSnapshot,
    userReference: DocumentReference
) => {
    const querySnapshot = await userReference.collection('events').where('name', '==', taskSnapshot.get('event')).get();
    return querySnapshot.docs[0].ref;
}

/// Increments the necessary fields in the event and user documents linked to this task.
const incrementFromPriority = async (
    priority: number,
    eventReference: DocumentReference,
    userReference: DocumentReference,
    value: FieldValue,
) => {
    let userFieldName: string = '';
    let eventFieldName: string = '';

    switch (priority) {
        case 0:
            userFieldName = 'pendingLow';
            eventFieldName = 'lowPriority';
            break;
        case 1:
            userFieldName = 'pendingMedium';
            eventFieldName = 'mediumPriority';
            break;
        case 2:
            userFieldName = 'pendingHigh';
            eventFieldName = 'highPriority';
            break;
    }

    await eventReference.update({ [eventFieldName]: value });
    await userReference.update({ [userFieldName]: value });
}

/// Incrementsj only the 'pendingTasks' field for the provided event.
const incrementPendingTasks = async (
    eventReference: DocumentReference,
    value: FieldValue
) => {
    await eventReference.update({ 'pendingTasks': value });
}

export const pendingTasksUpdater: functions.CloudFunction<functions.Change<FirebaseFirestore.DocumentSnapshot>> = functions.firestore
    .document('tasks/{taskId}')
    .onWrite(async (change, _) => {
        /// Snapshot of the document before the operation.
        ///
        /// Only applicable for update and delete operations.
        const before: DocumentSnapshot = change.before;

        /// Snapshot of the document after the operation.
        ///
        /// Only applicable for update and create operations.
        const after: DocumentSnapshot = change.after;

        /// Operation performed to the task.
        let action: string;

        /// Reference to the user dociment linked to this task.
        let userDocument: DocumentReference;

        /// Reference to the event document linked to this task before the operation.
        let eventDocument: DocumentReference;

        /// Reference to the event document linked to this task after the operation.
        let eventDocumentBefore: DocumentReference | null;


        if (change.after.exists && change.before.exists) {
            /// Exit the funciton if case this is an update operation and the
            /// event and priority of the taks haven't changed.
            if (before.get('priority') === after.get('priority') || before.get('event') === after.get('event') || before.get('done') === after.get('done')) {
                console.log('Nothing to update, exiting function');
                return true;
            }
            userDocument = await getUserReference(after);
            eventDocumentBefore = await getEventReference(before, userDocument);
            eventDocument = await getEventReference(after, userDocument);
            action = 'update';
        } else if (!change.before.exists) {
            userDocument = await getUserReference(after);
            eventDocument = await getEventReference(after, userDocument);
            action = 'create';
        } else {
            userDocument = await getUserReference(before);
            eventDocument = await getEventReference(before, userDocument);
            action = 'delete';
        }

        switch (action) {
            case 'create':
                await incrementFromPriority(after.get('priority'), eventDocument, userDocument, incrementValue);
                await incrementPendingTasks(eventDocument, incrementValue);
                break;
            case 'delete':
                await incrementFromPriority(before.get('priority'), eventDocument, userDocument, decrementValue);
                await incrementPendingTasks(eventDocument, decrementValue);
                break;
            case 'update':
                if (before.get('done') !== after.get('done')) {
                    const value = after.get('done') ? decrementValue : incrementValue;
                    await incrementFromPriority(after.get('priority'), eventDocument, userDocument, value);
                    await incrementPendingTasks(eventDocument, value);
                }
                if (before.get('priority') !== after.get('priority')) {
                    await incrementFromPriority(before.get('priority'), eventDocumentBefore!, userDocument, decrementValue);
                    await incrementFromPriority(after.get('priority'), eventDocument, userDocument, incrementValue);
                }
                if (before.get('event') !== after.get('event')) {
                    await incrementPendingTasks(eventDocumentBefore!, decrementValue);
                    await incrementPendingTasks(eventDocument, incrementValue);
                }
                break;
        }

        console.log('Successfully updated user and event due to task update');
        return true;
    });