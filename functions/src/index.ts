import * as functions from 'firebase-functions';
import { Storage } from '@google-cloud/storage';

const gcs = new Storage();

import { tmpdir } from 'os';
import { join, dirname } from 'path';

import * as sharp from 'sharp';
import * as fs from 'fs-extra';

export const generateThumb = functions.storage.object().onFinalize(async object => {
    // Find the bucket where the uploaded dile resides.
    const bucket = gcs.bucket(object.bucket);
    const filePathGcs = object.name;
    const fileName = filePathGcs!.split('/').pop();

    const bucketDirectory = dirname(filePathGcs!);
    const workingDirectory = join(tmpdir(), 'thumbnails');
    const tmpFilePath = join(workingDirectory, 'source.png');

    if (fileName!.includes('thumb@') || !object.contentType!.includes('image')) {
        console.log('Exiting function');
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
        .resize(124, 124)
        .toFile(thumbnailLocalPath);

    // Upload the resulting thumnail to the same directory as the original file.
    await bucket.upload(thumbnailLocalPath, {
        destination: join(bucketDirectory, thumbnailName),
    });

    // Exit the function deleting all the temprorary files.
    return fs.remove(workingDirectory);
});