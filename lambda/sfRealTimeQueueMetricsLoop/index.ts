import { Lambda } from 'aws-sdk';

const client = new Lambda({
  region: process.env.DEFAULT_REGION,
});

export const handler = async ({ iterator: { index, count } }: EventInput): Promise<EventOutput> => {
  console.log('Start Execution : RealTimeMetricsLoopJob');
  // next index
  const nextIndex = index + 1;
  // lambda arn
  const lambdaArn = process.env.SFDC_REALTIME_QUEUE_METRICS_LAMBDA;

  console.log(`LambdaArn: ${lambdaArn}`);

  if (!lambdaArn) {
    throw new Error('SFDC_REALTIME_QUEUE_METRICS_LAMBDA is empty!');
  }

  // call lambda
  await client
    .invoke({
      FunctionName: lambdaArn,
      InvocationType: 'Event',
    })
    .promise();

  return {
    index: nextIndex,
    continue: nextIndex < count,
    count,
  };
};

export interface EventInput {
  iterator: {
    count: number;
    index: number;
  };
}

export interface EventOutput {
  index: number;
  continue: boolean;
  count: number;
}
