import * as functions from 'firebase-functions';

import { generateThumb } from './generate_thumb';
import { pendingTasksUpdater } from './pending_tasks_updater';

export const generate_thumb: functions.CloudFunction<functions.storage.ObjectMetadata> = generateThumb;
export const pending_tasks_updater: functions.CloudFunction<functions.Change<FirebaseFirestore.DocumentSnapshot>> = pendingTasksUpdater;