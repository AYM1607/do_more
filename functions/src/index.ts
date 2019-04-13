import * as functions from 'firebase-functions';

import { generateThumb } from './generate_thumb';

export const generate_thumb: functions.CloudFunction<functions.storage.ObjectMetadata> = generateThumb;