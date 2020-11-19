export interface SalesforceEvent {
  sf_operation: string;
  sf_object?: string;
  sf_fields?: string;
  sf_phone?: string;
  sf_id?: string;
  Origin?: string;
  Status?: string;
  ContactId?: string;
  Subject?: string;
  Priority?: string;
  Homephone?: string;
  Status?: string;
}

export interface ContactFlowEvent {
  Name: string;
  Details: {
    ContactData: {
      Attributes?: {
        [key: string]: string;
      };
      Channel: string;
      ContactId: string;
      CustomerEndpoint: {
        Address: string;
        Type: string;
      };
      InitialContactId: string;
      InitiationMethod: string;
      InstanceARN: string;
      MediaStreams: {
        Customer: {
          Audio?: unknown;
        };
      };
      PreviousContactId: string;
      Queue?: string;
      SystemEndpoint: {
        Address: string;
        Type: string;
      };
    };
    Parameters?: {
      [key: string]: string;
    };
  };
}

export interface SalesforceSecrets {
  access_token: string;
  consumer_key: string;
  consumer_secret: string;
  username: string;
  password: string;
}

export namespace Salesforce {
  interface CreateEvent {
    sf_object: string;
    params: {
      [key: string]: any;
    };
  }

  interface UpdateEvent {
    sf_object: string;
    sf_id: string;
    params: {
      [key: string]: any;
    };
  }

  interface DestroyEvent {
    sf_object: string;
  }
}
