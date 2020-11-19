import { Lambda } from 'aws-sdk';
import { KinesisStreamEvent } from 'aws-lambda';

const POSTCALL_RECORDING_IMPORT_ENABLED = process.env.POSTCALL_RECORDING_IMPORT_ENABLED;
const POSTCALL_TRANSCRIBE_ENABLED = process.env.POSTCALL_TRANSCRIBE_ENABLED;
const POSTCALL_CTR_IMPORT_ENABLED = process.env.POSTCALL_CTR_IMPORT_ENABLED;

const EXECUTE_TRANSCRIPTION_STATE_MACHINE_LAMBDA = process.env.EXECUTE_TRANSCRIPTION_STATE_MACHINE_LAMBDA as string;
const EXECUTE_CTR_IMPORT_LAMBDA = process.env.EXECUTE_CTR_IMPORT_LAMBDA as string;

const client = new Lambda({
  region: process.env.AWS_DEFAULT_REGION,
});

export const handler = async (event: KinesisStreamEvent): Promise<void> => {
  console.log('Event', event);

  const tasks = event.Records.map(async (item) => {
    if (Boolean(POSTCALL_RECORDING_IMPORT_ENABLED) || Boolean(POSTCALL_TRANSCRIBE_ENABLED)) {
      console.log('Invoke  EXECUTE_TRANSCRIPTION_STATE_MACHINE_LAMBDA');

      return await client
        .invoke({
          FunctionName: EXECUTE_TRANSCRIPTION_STATE_MACHINE_LAMBDA,
          InvocationType: 'Event',
          Payload: JSON.parse(item.kinesis.data),
        })
        .promise();
    }

    if (Boolean(POSTCALL_CTR_IMPORT_ENABLED)) {
      console.log('Invoke  EXECUTE_CTR_IMPORT_LAMBDA');

      return await client
        .invoke({
          FunctionName: EXECUTE_CTR_IMPORT_LAMBDA,
          InvocationType: 'Event',
          Payload: JSON.parse(item.kinesis.data),
        })
        .promise();
    }
  });

  await Promise.all(tasks);
};
