import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { DocumentSnapshot } from 'firebase-functions/lib/providers/firestore';
import { DocumentReference } from '@google-cloud/firestore';

admin.initializeApp();


const incrementValue = admin.firestore.FieldValue.increment(1);
const decrementValue = admin.firestore.FieldValue.increment(-1);
const db = admin.firestore();

let getUserReference = async (taskSnapShot: DocumentSnapshot) => {
    const querySnapshot = await db.collection('users').where('username', '==', taskSnapShot.get('ownerUsername')).get()
    return querySnapshot.docs[0].ref;
}

let getEventReference = async (taskSnapshot: DocumentSnapshot, userReference: DocumentReference) => {
    const querySnapshot = await userReference.collection('events').where('name', '==', taskSnapshot.get('event')).get();
    return querySnapshot.docs[0].ref;
}

let incrementFromPriority = (
    priority: number,
    eventReference: DocumentReference,
    userReference: DocumentReference,
    value: FirebaseFirestore.FieldValue,
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

    eventReference.update({ [eventFieldName]: value });
    userReference.update({ [userFieldName]: value });
}

export const pendingTasksUpdater: functions.CloudFunction<functions.Change<FirebaseFirestore.DocumentSnapshot>> = functions.firestore
    .document('tasks/{taskId}')
    .onWrite(async (change, _) => {
        const before: DocumentSnapshot = change.before;
        const after: DocumentSnapshot = change.after;
        let action: string;
        let userDocument: DocumentReference;
        let eventDocument: DocumentReference;
        let eventDocumentBefore: DocumentReference | null;

        if (change.after.exists && change.before.exists) {
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
                incrementFromPriority(after.get('priority'), eventDocument, userDocument, incrementValue);
                break;
            case 'delete':
                incrementFromPriority(before.get('priority'), eventDocument, userDocument, decrementValue);
                break;
            case 'update':
                incrementFromPriority(before.get('priority'), eventDocumentBefore!, userDocument, decrementValue);
                incrementFromPriority(after.get('priority'), eventDocument, userDocument, incrementValue);
                break;
        }

        console.log('Successfully updated user and event due to task update');
        return true;
    });