## Products

This is the main concept in the system all other things are built around. The Product could be 
considered as a main account for any merchant/business owner who wants to use Kartera API. It
includes some personal information about the owner and other technical information to support
all API functionality. What is important is the fact that all other entities in the system 
(product users, api keys, rewards, payments, etc) they are product-scoped and not available for
anyone else outside this scope.

Common Product operations are:

- [listing](open-api.md#get-v1products)
- [getting specific instance](open-api.md#get-v1productsid)

## Partners

Partner is the owner of a product. Partner is the first entity created during the initial onboarding process.
It contains personal details of the merchant/business owner and is the subject for initial verification.
From a technical point of view (if we're talking about financial aspects) the account-receiver that gets
all incoming payments is open under the name of the partner.  


Common Partner operations are:

- [listing](open-api.md#get-v1partners)
- [creating](open-api.md#post-v1partners)
- [getting specific instance](open-api.md#get-v1partnersid)
- [updating specific instance](open-api.md#patch-v1partnersid)

## Partner Users

A `partner user` it's an entity that represents and identifies a specific person that is able to perform some
partner-scoped operations on behalf of the `partner`. The amount of operations is detected by their roles: full access,
limited access or read-only access.


Common `partner user` operations are:

- [listing](open-api.md#get-v1partner_users)
- [creating](open-api.md#post-v1partner_users)
- [getting specific instance](open-api.md#get-v1partner_usersid)
- [updating specific instance](open-api.md#patch-v1partner_usersid)

## Product Users

Product users are end-users of the service—they perform payments and use rewards (create the main money flow).

Common `product user` operations are:

- [listing](open-api.md#get-v1partners)
- [creating](open-api.md#post-v1partners)
- [getting specific instance](open-api.md#get-v1partnersid)
- [updating specific instance](open-api.md#patch-v1partnersid)

## JWT tokens

The typical authentication mechanism used for some endpoints (used mostly by Kartera UI itself).

## API key

The single available authentication mechanism used for communication with Kartera API. 
ALl keys are unique and contain partner and product inside, so the y are detected from it.
The key should be specified as a value in custom HTTP header `X-Api-Key`.

## Payments

Payments are financial operations that are performed by `product users` or `partner users` in the system.
They could be of two types: `INCOMING` (moving from `product users` to the system) and `OUTGOING` (moving
from the system to `product users`).

Common `payment` operations are:

- [creating](open-api.md#post-v1payments)
- [searching](open-api.md#post-v1paymentssearch)
- [getting specific instance](open-api.md#get-v1paymentsid)

## Rewards

Rewards are incentives that `partner` can set for his `product users` for `payments` they perform in the system.
At the moment, several reward types are available (with different options for their activation): `INSTANT_DISCOUNT`,
`CASHBACK` and `POINT_SYSTEM`.

## Onboarding

This is an initial steps of the system setting up for usage by `partner`. During this process:

1. Business owner provides some detailed information about himself and his business
2. Provides some identification information
3. The system performs some validation
4. In successful case - opens account and initiates basic setup for `partner` and `product`

## Webhooks

Webhooks provide a notification mechanism for some long-lasting operations like verification or payment.

Common `webhook` operations are:

- [listing](open-api.md#get-v1webhooks)
- [getting specific instance](open-api.md#get-v1webhooksid)
- [creating](open-api.md#post-v1webhooks)
- [deleting](open-api.md#delete-v1webhooksid)


## Linked Accounts

It's an entity that keeps some bank-specific information (partially available for representation) that used 
during validation and verification stages of payments and refunds.

Common `linked account` operations are:

- [listing](open-api.md#get-v1linked_accounts)
- [getting specific instance](open-api.md#get-v1linked_accountsid)
- [creating](open-api.md#post-v1linked_accounts)
- [deleting](open-api.md#delete-v1linked_accountsid)
  
 
## Recurring payments

Recurring payments are solution for some routine tasks as utility bill payments or charity donations.
After it was created it starts its periodic execution in intervals that were specified during its creation. 

Common `recurring payment` operations are:

- [listing](open-api.md#get-v1recurring_payments)
- [getting specific instance](open-api.md#get-v1recurring_paymentsid)
- [creating](open-api.md#post-v1recurring_payments)
- [deleting](open-api.md#delete-v1recurring_paymentsid)
  
