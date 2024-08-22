## Basic Operation Flows

Kartera API provides many operations available for automation by `partner`'s services with the help of the REST endpoints.
Some of them are fully available through API, some require steps executed in UI.
Each section describes an operation, its place in general flow and required steps (`API` or `UI` after a step will indicate the way it could be done).

### Linked Account operations

`linked account` should be created for each account or bank user have for performing `pay-by-bank` payments.
Kartera provides this service with the help of 3rd party service ([Plaid](https://plaid.com)), so some minimalistic communication with it is needed.
The flow is:

1. Create a product user (`UI`/`API`)
2. Request plaid link token ([API](open-api.md#get-v1usersidrequest_plaid_link_token)) 
3. In partner `partner`'s services UI provide access to the user to [Plaid's Link React component](https://plaid.com/docs/link) and initiate it by the token from the previous step
4. Resulting `access_token` use the [API endpoint](open-api.md#post-v1linked_accounts) for creating `linked account` 

### Payment operations

Payments are the most used operations of Kartera API. They use the information about `product-user`'s bank/account 
they connected with the help of `linked-account`.

The flow is:

1. Create a product user (`UI`/`API`)
2. Request plaid link token ([API](open-api.md#get-v1usersidrequest_plaid_link_token))
3. In partner `partner`'s services UI provide access to the user to [Plaid's Link React component](https://plaid.com/docs/link) and initiate it by the token from the previous step
4. Resulting `access_token` use the [API endpoint](open-api.md#post-v1linked_accounts) for creating `linked account`
5. Call payments [API endpoint](open-api.md#post-v1payments), providing `linked accound`'s ID
    1. payment will perform balance verification
    2. initiate payment/refund
    3. update rewards information
    4. call a webhook on completion (failed/successful) 

### Recurring payment operations

Recurring payment operations are `payment` operations executed on a specified interval.

The flow is:

1. Create a product user (`UI`/`API`)
2. Request plaid link token ([API](open-api.md#get-v1usersidrequest_plaid_link_token))
3. In partner `partner`'s services UI provide access to the user to [Plaid's Link React component](https://plaid.com/docs/link) and initiate it by the token from the previous step
4. Resulting `access_token` use the [API endpoint](open-api.md#post-v1linked_accounts) for creating `linked account`
5. Create a recurring payment [API endpoint](open-api.md#post-v1recurring_payments), providing `linked accound`'s ID
