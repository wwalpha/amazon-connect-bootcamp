import { S3 } from 'aws-sdk';
import { S3Event } from 'aws-lambda';

const client = new S3({
  region: process.env.AWS_DEFAULT_REGION,
});

const SF_ADAPTER_NAMESPACE = process.env.SF_ADAPTER_NAMESPACE as string;

export const handler = async (event: S3Event): Promise<void> => {
  console.log(event);

  const record = event.Records[0];
  const bucket = record.s3.bucket.name;
  const key = record.s3.object.key;

  console.log(`bucket: ${bucket}, key: ${key}`);

  const file = await client
    .getObject({
      Bucket: bucket,
      Key: key,
    })
    .promise();
};

//   sf = Salesforce()
//   sf.sign_in()

//   for record in csv.DictReader(data.split("\n")):
//     queue_record = prepare_queue_record(record, event_record['eventTime'])
//     ac_record_id = "%s%s" % (queue_record[pnamespace + 'AC_Object_Name__c'], queue_record[pnamespace + 'StartInterval__c'])
//     #logger.info("sfIntervalAgent ac_record_id: %s" % ac_record_id)
//     #logger.info("sfIntervalAgent record: %s" % queue_record)
//     # logger.info("sfIntervalAgent record: %s" % agent_record)
//     sf.update_by_external(pnamespace + "AC_HistoricalQueueMetrics__c", pnamespace + 'AC_Record_Id__c', ac_record_id,queue_record)

//   logger.info("done")

// def prepare_queue_record(record_raw, current_date):
//   record = {label_parser(k):value_parser(v) for k, v in record_raw.items()}
//   #record[pnamespace + 'Type__c'] = "Queue"
//   record[pnamespace + 'Created_Date__c'] = current_date
//   #record[pnamespace + 'AC_Record_Id__c'] = "%s%s" % (record[pnamespace + 'AC_Object_Name__c'], current_date)
//   return record

// def label_parser(key):
//   if key.lower() == 'average agent interaction and customer hold time':
//     return pnamespace + 'Avg_agent_interaction_and_cust_hold_time__c'

//   if key.lower() == "queue":
//     return pnamespace + "AC_Object_Name__c"

//   return pnamespace + "%s__c" % key.replace(" ", "_")

// def value_parser(value):
//   return value.replace("%", "") if len(value) > 0 else None
