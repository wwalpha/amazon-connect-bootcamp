import { SecretsManager } from 'aws-sdk';
import { Connection, QueryResult, UserInfo } from 'jsforce';
import { ContactFlowEvent, Salesforce, SalesforceEvent, SalesforceSecrets } from 'types/types';

const conn = new Connection({ loginUrl: process.env.XXX });
const SECRET_KEY_NAME = process.env.SECRET_KEY_NAME as string;

const client = new SecretsManager({
  region: process.env.AWS_DEFAULT_REGION,
});

export const handler = async (event: ContactFlowEvent): Promise<unknown | void> => {
  // get secret values from secret manager
  const resp = await client.getSecretValue({ SecretId: SECRET_KEY_NAME }).promise();

  // decode secret values
  const binary = (resp.SecretString ||= '');
  const secretString = Buffer.from(binary, 'base64').toString('ascii');
  const secrets = JSON.parse(secretString) as SalesforceSecrets;

  // salesforce login
  const userInfo = await conn.login(secrets.username, secrets.password);

  // get parameters from amazon connect
  const params = (event.Details.Parameters as unknown) as SalesforceEvent;
  const operation = params.sf_operation;

  let results;
  if (operation === 'lookup') {
    results = await lookup(params);
  } else if (operation === 'create') {
    // insert subject
    await create(params);
  } else if (operation === 'update') {
    // update status
    await update(params);
  } else if (operation === 'phoneLookup') {
    throw new Error('sf_operation phoneLookup');
  } else if (operation === 'lookup_all') {
    throw new Error('sf_operation lookup_all');
  } else if (operation === 'query') {
    throw new Error('sf_operation query');
  } else if (operation === 'queryOne') {
    throw new Error('sf_operation queryOne');
  } else if (operation === 'createChatterPost') {
    throw new Error('sf_operation createChatterPost');
  } else if (operation === 'createChatterComment') {
    throw new Error('sf_operation createChatterComment');
  } else if (operation === 'search') {
    throw new Error('sf_operation search');
  } else if (operation === 'searchOne') {
    searchOne(params);
  } else {
    throw new Error('sf_operation unknown');
  }

  return results;
};

// def lookup(sf, sf_object, sf_fields, **kwargs):
//   where = " AND ".join([where_parser(*item) for item in kwargs.items()])
//   query = "SELECT %s FROM %s WHERE %s" % (sf_fields, sf_object, where)
//   records = sf.query(query=query)
//   count = len(records)
//   result = records[0] if count > 0 else {}
//   result['sf_count'] = count
//   return result

const lookup = async (event: SalesforceEvent) => {
  const results = await conn.query('SELECT %s FROM %s WHERE %s');

  return {
    sf_count: results.totalSize,
    records: results.records,
  };
};

/** create object */
const create = async (event: SalesforceEvent) => {
  const object = event.sf_object as string;
  const params = {
    Origin: event.Origin,
    Status: event.Status,
    ContactId: event.ContactId,
    Subject: event.Subject,
    Priority: event.Priority,
  };

  await conn.sobject(object).create(params);
};

/** update object */
const update = async (event: SalesforceEvent) => {
  const object = event.sf_object as string;

  await conn.sobject(object).update({
    Id: event.sf_id,
    Status: event.Status,
  });
};

const searchOne = (event: SalesforceEvent) => {};

// def searchOne(sf, q, sf_fields, sf_object, where="", **kwargs):
//   obj = [ { 'name': sf_object } ]
//   if where:
//     obj[0]['where'] = where

//   data = {
//     'q':q,
//     'fields': sf_fields.split(', '),
//     'sobjects': obj
//   }
//   records = sf.parameterizedSearch(data=data)
//   count = len(records)
//   result = flatten_json(records[0]) if count == 1 else {}
//   result['sf_count'] = count
//   return result

// def lambda_handler(event, context):
//   logger.info("event: %s" % json.dumps(event))
//   sf = Salesforce()
//   sf.sign_in()

//   elif (sf_operation == "create"):
//     resp = create(sf=sf, **event['Details']['Parameters'])
//   elif (sf_operation == "update"):
//     resp = update(sf=sf, **event['Details']['Parameters'])
//   elif (sf_operation == "phoneLookup"):
//     resp = phoneLookup(sf, event['Details']['Parameters']['sf_phone'], event['Details']['Parameters']['sf_fields'])
//   elif (sf_operation == "delete"):
//     resp = delete(sf=sf, **event['Details']['Parameters'])
//   elif (sf_operation == "lookup_all"):
//     resp = lookup_all(sf=sf, **event['Details']['Parameters'])
//   elif (sf_operation == "query"):
//     resp = query(sf=sf, **event['Details']['Parameters'])
//   elif (sf_operation == "queryOne"):
//     resp = queryOne(sf=sf, **event['Details']['Parameters'])
//   elif (sf_operation == "createChatterPost"):
//     resp = createChatterPost(sf=sf, **event['Details']['Parameters'])
//   elif (sf_operation == "createChatterComment"):
//     resp = createChatterComment(sf=sf, **event['Details']['Parameters'])
//   elif (sf_operation == "search"):
//     resp = search(sf=sf, **event['Details']['Parameters'])
//   elif (sf_operation == "searchOne"):
//     resp = searchOne(sf=sf, **event['Details']['Parameters'])
//   else:
//     msg = "sf_operation unknown"
//     logger.error(msg)
//     raise Exception(msg)

//   logger.info("result: %s" % resp)
//   return resp

// def where_parser(key, value):
//   if key.lower() in ['mobilephone', 'homephone']:
//     return "%s LIKE '%%%s%%%s%%%s%%'" % (key, value[-10:-7], value[-7:-4], value[-4:])

//   if "%" in value:
//     return "%s LIKE '%s'" % (key, value)

//   return "%s='%s'" % (key, value)

// def create(sf, sf_object, **kwargs):
//   data = {k:parse_date(v) for k,v in kwargs.items()}
//   return {'Id':sf.create(sobject=sf_object, data=data)}

// def update(sf, sf_object, sf_id, **kwargs):
//   data = {k:parse_date(v) for k,v in kwargs.items()}
//   return {'Status':sf.update(sobject=sf_object, sobj_id=sf_id, data=data)}

// def phoneLookup(sf, phone, sf_fields):
//   phone_national = str(phonenumbers.parse(phone, None).national_number)

//   data = {
//     'q':phone_national,
//     'sobjects':[{'name': 'Contact'}],
//     'fields': sf_fields.split(", ") if isinstance(sf_fields, str) else sf_fields
//   }
//   records = sf.parameterizedSearch(data=data)

//   count = len(records)

//   if (count > 0):
//     result = records[0]
//   else:
//     result = {}

//   result['sf_count'] = count
//   return result

// def delete(sf, sf_object, sf_id):
//   return {'Response': sf.delete(sobject=sf_object, sobject_id=sf_id)}

// # ****WARNING**** -- this function will be deprecated in future versions of the integration; please use search/searchOne.
// def lookup_all(sf, sf_object, sf_fields, **kwargs):
//   where = " AND ".join([where_parser(*item) for item in kwargs.items()])
//   query_filter = (" WHERE" + where) if kwargs.__len__() > 0 else ''
//   query = "SELECT %s FROM %s  %s" % (sf_fields, sf_object, query_filter)
//   records = sf.query(query=query)
//   return records

// # ****WARNING**** -- this function will be deprecated in future versions of the integration; please use search/searchOne.
// def query(sf, query, **kwargs):
//   for key, value in kwargs.items():
//     logger.info("Replacing [%s] with [%s] in [%s]" % (key, value, query))
//     query = query.replace(key, value)

//   records = sf.query(query=query)
//   count = len(records)
//   result = {}

//   if count > 0:
//     recordArray = []
//     for record in records :
//       recordArray.append(flatten_json(record))

//     result['sf_records'] = recordArray
//   else:
//     result['sf_records'] = []

//   result['sf_count'] = count
//   return result

// # ****WARNING**** -- this function will be deprecated in future versions of the integration; please use search/searchOne.
// def queryOne(sf, query, **kwargs):
//   for key, value in kwargs.items():
//     logger.info("Replacing [%s] with [%s] in [%s]" % (key, value, query))
//     query = query.replace(key, value)

//   records = sf.query(query=query)
//   count = len(records)
//   result = flatten_json(records[0]) if count == 1 else {}
//   result['sf_count'] = count
//   return result

// def createChatterPost(sf, sf_feedElementType, sf_subjectId, sf_messageType, sf_message, **kwargs):
//   formatted_message = text_replace_string(sf_message, kwargs)
//   logger.info('Formatted message: %s', formatted_message)

//   data = {'sf_feedElementType': sf_feedElementType,
//           'sf_subjectId': sf_subjectId,
//           'sf_messageType': sf_messageType,
//           'sf_message': formatted_message,
//           'sf_mention': kwargs.get('sf_mention','')}

//   return {'Id': sf.createChatterPost(data)}

// def createChatterComment(sf, sf_feedElementId, sf_commentType, sf_commentMessage, **kwargs):
//   formatted_message = text_replace_string(sf_commentMessage, kwargs)
//   logger.info('Formatted message: %s', formatted_message)

//   data = {'sf_feedElementId': sf_feedElementId,
//           'sf_commentType': sf_commentType,
//           'sf_commentMessage': formatted_message}

//   return {'Id': sf.createChatterComment(sfeedElementId=sf_feedElementId, data=data)}

// def search(sf, q, sf_fields, sf_object, where="", overallLimit=100, **kwargs):
//   obj = [ { 'name': sf_object } ]
//   if where:
//     obj[0]['where'] = where

//   data = {
//     'q':q,
//     'fields': sf_fields.split(', '),
//     'sobjects': obj,
//     'overallLimit': overallLimit
//   }
//   records = sf.parameterizedSearch(data=data)

//   count = len(records)
//   result = {}

//   if count > 0:
//     recordArray = []
//     for record in records:
//       recordArray.append(flatten_json(record))

//     result['sf_records'] = recordArray
//   else:
//     result['sf_records'] = []

//   result['sf_count'] = count
//   return result

// def flatten_json(nested_json):
//   out = {}

//   def flatten(x, name=''):
//     if type(x) is dict:
//       for a in x:
//         flatten(x[a], name + a + '.')
//     elif type(x) is list:
//       i = 0
//       for a in x:
//         flatten(a, name)
//         i += 1
//     else:
//       out[name[:-1]] = x

//   flatten(nested_json)
//   return out
