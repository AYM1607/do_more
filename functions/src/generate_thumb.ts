import * as functions from 'firebase-functions';
import { Storage } from '@google-cloud/storage';

const gcs = new Storage();

import { tmpdir } from 'os';
import { join, dirname } from 'path';

import * as sharp from 'sharp';
import * as fs from 'fs-extra';

/// Creates a thumbnail for every image that gets uploaded to the storage bucket.
export const generateThumb: functions.CloudFunction<functions.storage.ObjectMetadata> = functions.storage.object().onFinalize(async object => {
    // Find the bucket where the uploaded file resides.
    const bucket = gcs.bucket(object.bucket);

    // Find the path of the file inside the bucket.
    const filePathGcs = object.name;

    // Save the name of the file.
    const fileName = filePathGcs!.split('/').pop();

    // Directory where the file is stored inside the bucket.
    const bucketDirectory = dirname(filePathGcs!);
    const workingDirectory = join(tmpdir(), 'thumbnails');
    const tmpFilePath = join(workingDirectory, fileName!);

    if (fileName!.includes('thumb@') || !object.contentType!.includes('image')) {
        console.log('Exiting function, already compressed or no image.');
        return false;
    }

    // Ensure that our directory exists.
    await fs.ensureDir(workingDirectory);

    // Download the source file to the temporary directory.
    await bucket.file(filePathGcs!).download({
        destination: tmpFilePath,
    });

    // Create the thumnail in 124 size.
    const thumbnailName = `thumb@${fileName}`;
    const thumbnailLocalPath = join(workingDirectory, thumbnailName);

    await sharp(tmpFilePath)
        .resize(256, 256)
        .toFile(thumbnailLocalPath);

    // Upload the resulting thumnail to the same directory as the original file.
    await bucket.upload(thumbnailLocalPath, {
        destination: join(bucketDirectory, thumbnailName),
    });
    console.log('Thumbnail created successfully')

    // Exit the function deleting all the temprorary files.
    return fs.remove(workingDirectory);
});