// import json, csv, os
// import boto3
// import urllib.parse
// from salesforce import Salesforce
// from sf_util import get_arg, parse_date, split_bucket_key

// import logging
// logger = logging.getLogger()
// logger.setLevel(logging.getLevelName(os.environ["LOGGING_LEVEL"]))
import { S3 } from 'aws-sdk';
import { S3Event } from 'aws-lambda';

const client = new S3({
  region: process.env.AWS_DEFAULT_REGION,
});

const SF_ADAPTER_NAMESPACE = process.env.SF_ADAPTER_NAMESPACE as string;

export const handler = async (event: S3Event): Promise<void> => {
  console.log('Logging Start sfIntervalAgent');

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

  const data = file.Body?.toString();

  console.log(`sfIntervalAgent data: ${data}`);

  console.log('Done');
};

// def lambda_handler(event, context):

//   logger.info("bucket: %s" % bucket)

//   sf = Salesforce()
//   sf.sign_in()

//   for record in csv.DictReader(data.split("\n")):
//     logger.info("sfIntervalAgent record: %s" % record)

//     agent_record = prepare_agent_record(record, event_record['eventTime'])

//     ac_record_id = "%s%s" % (agent_record[pnamespace + 'AC_Object_Name__c'], agent_record[pnamespace + 'StartInterval__c'])

//     sf.update_by_external(pnamespace + "AC_AgentPerformance__c", pnamespace + 'AC_Record_Id__c',ac_record_id, agent_record)

//   logger.info("done")

// def prepare_agent_record(record_raw, current_date):
//   record = {label_parser(k):value_parser(v) for k, v in record_raw.items()}
//   #record[pnamespace + 'Type__c'] = "Agent"
//   record[pnamespace + 'Created_Date__c'] = current_date
//   #record[pnamespace + 'AC_Record_Id__c'] = "%s%s" % (record[pnamespace + 'AC_Object_Name__c'], current_date)
//   #record[pnamespace + 'AC_Record_Id__c'] = "%s%s" % (record[pnamespace + 'AC_Object_Name__c'], record[pnamespace + 'StartInterval__c'])
//   return record

// def label_parser(key):
//   if key.lower() == 'average agent interaction and customer hold time':#To Long
//     return pnamespace + 'Avg_agent_interaction_and_cust_hold_time__c'

//   if key.lower() == "agent":
//     return pnamespace + "AC_Object_Name__c"

//   return pnamespace + "%s__c" % key.replace(" ", "_")

// def value_parser(value):
//   return value.replace("%", "") if len(value) > 0 else None
