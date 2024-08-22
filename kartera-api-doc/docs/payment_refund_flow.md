# Payment/Refund flow

<!-- TOC -->
* [Payment/Refund flow](#paymentrefund-flow)
  * [Payment (cashback/discount)](#payment-cashbackdiscount)
  * [Payment (Points System)](#payment-points-system)
  * [Refund (cashback/discount)](#refund-cashbackdiscount)
  * [Refund (Points System)](#refund-points-system)
<!-- TOC -->

## Payment (cashback/discount)

```plantuml

@startuml

state start  <<start>>
state end    <<end>>


start  --> Calculate_Discount : discount is used in Rewards

Calculate_Discount: use reward for the product 

start  --> Validate_Payment: cashback is used in Rewards
Calculate_Discount --> Validate_Payment
Validate_Payment: - validate user
Validate_Payment: - validate linked account
Validate_Payment: - Amount for the final (discounted)\npayment is less than current balance for user
Validate_Payment: - Amount is greater than\nour current set minimum amount (4.00)

Validate_Payment --> Save_Payment_Into_DB : Success
Save_Payment_Into_DB : create a record into `payments`

Save_Payment_Into_DB --> Validate_Redeemed_Cashback : Success and `cashbackAmount` <> 0
Validate_Redeemed_Cashback: check that there is enough cashback for user to redeem

Validate_Redeemed_Cashback -> Create_Redeem_Cashback: Success
Create_Redeem_Cashback: create a record into `redeem_reward_cashbacks`

Create_Redeem_Cashback --> Calculate_Fee_Distribution: Success 
Save_Payment_Into_DB --> Calculate_Fee_Distribution: Success and `cashbackAmount` == 0 


Calculate_Fee_Distribution --> Save_Payment_Fees
Save_Payment_Fees : create a record into `payment_fees`

Save_Payment_Fees --> Initiate_All_Dwolla_Payments : Success
Initiate_All_Dwolla_Payments: call Dwolla API

Initiate_All_Dwolla_Payments --> Update_Dwolla_External_ID : Success

Validate_Payment --> end : Not Validated
Save_Payment_Into_DB --> end : Failure
Validate_Redeemed_Cashback --> end : Not Validated
Create_Redeem_Cashback --> end : Failure
Save_Payment_Fees --> end : Failure
Initiate_All_Dwolla_Payments --> end : Failure
Update_Dwolla_External_ID --> end


state "Process Dwolla Webhook\n(async process)" as Process_Dwolla_Webhook {
  state start2  <<start>>
  state end2    <<end>>

  start2 --> Create_Cashback: if payment is Accepted \nand cashback is used in Rewards\nONLY if cashbackAmount == 0
  Create_Cashback: create a record into `reward_cashbacks`
  
  Create_Cashback --> Update_Payment_Status
  
  start2 --> Cancel_Redeemed_Cashback: if payment is Rejected \nand cashback is used in Rewards
  Cancel_Redeemed_Cashback --> Update_Payment_Status
  
  start2 --> Update_Payment_Status : Any other cases
 
  Update_Payment_Status -->  Notify_Payment_Status_Subscribers
  Notify_Payment_Status_Subscribers --> end2
  
}


@enduml

```



## Payment (Points System)

```plantuml

@startuml

state start  <<start>>
state end    <<end>>

start  --> Validate_Payment: point is used in Rewards
Validate_Payment: - validate user
Validate_Payment: - validate linked account
Validate_Payment: - there is enough story points if they are used
Validate_Payment: - Amount for the final\npayment is less than current balance for user
Validate_Payment: - Amount is greater than\nour current set minimum amount (4.00)

Validate_Payment --> Save_Payment_Into_DB : Success
Save_Payment_Into_DB : create a record into `payments`

Save_Payment_Into_DB --> Validate_Redeemed_Reward_Points : Success and `pointsAmount` <> 0
Validate_Redeemed_Reward_Points: check that there is enough reward points for user to redeem

Validate_Redeemed_Reward_Points -> Create_Redeemed_Reward_Points: Success
Create_Redeemed_Reward_Points: create a record into `redeem_reward_points`

Create_Redeemed_Reward_Points --> Mark_Intro_Offer_as_Used : if conditions are matching\nand it wasn't used
Save_Payment_Into_DB --> Mark_Intro_Offer_as_Used: if conditions are matching\nand it wasn't used
Mark_Intro_Offer_as_Used: set 'INTRO_OFFER_USED' in product_user table

Create_Redeemed_Reward_Points --> Calculate_Fee_Distribution: Success 
Save_Payment_Into_DB --> Calculate_Fee_Distribution: Success and `pointsAmount` == 0 
Mark_Intro_Offer_as_Used--> Calculate_Fee_Distribution: Success 

Calculate_Fee_Distribution --> Save_Payment_Fees
Save_Payment_Fees : create a record into `payment_fees`

Save_Payment_Fees --> Initiate_All_Dwolla_Payments : Success
Initiate_All_Dwolla_Payments: call Dwolla API

Initiate_All_Dwolla_Payments --> Update_Dwolla_External_ID : Success

Validate_Payment --> end : Not Validated
Save_Payment_Into_DB --> end : Failure
Validate_Redeemed_Reward_Points --> end : Not Validated
Create_Redeemed_Reward_Points --> end : Failure
Save_Payment_Fees --> end : Failure
Initiate_All_Dwolla_Payments --> end : Failure
Update_Dwolla_External_ID --> end


state "Process Dwolla Webhook\n(async process)" as Process_Dwolla_Webhook {
  state start2  <<start>>
  state end2    <<end>>

  start2 --> Create_Reward_Points: if payment is Accepted\nONLY if pointsAmount == 0
  Create_Reward_Points: create a record into `reward_points`
  Create_Reward_Points: check an option with Intro-Offer
  Create_Reward_Points --> Update_Payment_Status
  
 
  start2 --> Cancel_Redeemed_Reward_Points: if payment is Rejected \nand points are used in Rewards
  Cancel_Redeemed_Reward_Points --> Update_Payment_Status
  
  Cancel_Redeemed_Reward_Points --> Undo_Mark_Intro_Offer_as_Used : if was set by this payment
  Undo_Mark_Intro_Offer_as_Used -->  Update_Payment_Status
  
  start2 --> Update_Payment_Status : Any other cases
 
  
  Update_Payment_Status -->  Notify_Payment_Status_Subscribers
  Notify_Payment_Status_Subscribers --> end2
  
}


@enduml

```


## Refund (cashback/discount)

```plantuml

@startuml

state start  <<start>>
state end    <<end>>


start  --> Validate_Refund
Validate_Refund: - validate user
Validate_Refund: - validate linked account
Validate_Refund: - Amount for refund is equal\nto amount for in-payment 
Validate_Refund: - Payment is not already reverted
Validate_Refund: - there should be no other reward for\n the specified original payment in req

Validate_Refund --> Save_Refund_Into_DB : Success
Save_Refund_Into_DB : create a record into `payments`

Save_Refund_Into_DB --> Cancel_Redeemed_Cashback : if the original payment\nis specified in req
Cancel_Redeemed_Cashback --> Mark_Original_Payment_As_Reverted
Mark_Original_Payment_As_Reverted --> Mark_Cashback_As_Deactivated

Mark_Cashback_As_Deactivated--> Initiate_All_Dwolla_Refunds 
Mark_Cashback_As_Deactivated:  record into `reward_cashbacks` set `ACTIVE` = false

Save_Refund_Into_DB --> Initiate_All_Dwolla_Refunds : Success

Initiate_All_Dwolla_Refunds --> Update_Dwolla_External_ID : Success
Initiate_All_Dwolla_Refunds: call Dwolla API

Update_Dwolla_External_ID --> end 

Validate_Refund --> end : Not Validated
Save_Refund_Into_DB --> end : Failure
Initiate_All_Dwolla_Refunds --> end : Failure

state "Process Dwolla Webhook\n(async process)" as Process_Dwolla_Webhook {
  state start2  <<start>>
  state end2    <<end>>

  start2 --> Undo_Cancel_Redeemed_Cashback: if payment is Rejected \nand the original payment was specified
  Undo_Cancel_Redeemed_Cashback --> Undo_Mark_Original_Payment_As_Reverted
  
  Undo_Mark_Original_Payment_As_Reverted --> Undo_Mark_Cashback_As_Deactivated
  
  Undo_Mark_Cashback_As_Deactivated --> Update_Payment_Status
  Undo_Mark_Cashback_As_Deactivated : the cashback that has been\ncreated by original payment
  Undo_Mark_Cashback_As_Deactivated :  record into `reward_cashbacks` set `ACTIVE` = true
 
  
  start2 --> Update_Payment_Status: Any other cases
 
  Update_Payment_Status -->  Notify_Payment_Status_Subscribers
  Notify_Payment_Status_Subscribers --> end2
  
  
}


@enduml

```


## Refund (Points System)

```plantuml

@startuml

state start  <<start>>
state end    <<end>>


start  --> Validate_Refund
Validate_Refund: - validate user
Validate_Refund: - validate linked account
Validate_Refund: - Amount for refund is equal\nto amount for in-payment 
Validate_Refund: - Payment is not already reverted
Validate_Refund: - there should be no other reward for\n the specified original payment in req

Validate_Refund --> Save_Refund_Into_DB : Success
Save_Refund_Into_DB : create a record into `payments`

Save_Refund_Into_DB --> Cancel_Redeemed_Reward_Points : if the original payment\nis specified in req
Cancel_Redeemed_Reward_Points --> Mark_Original_Payment_As_Reverted
Mark_Original_Payment_As_Reverted --> Mark_Reward_Points_As_Deactivated

Mark_Reward_Points_As_Deactivated --> Initiate_All_Dwolla_Refunds 
Mark_Reward_Points_As_Deactivated:  record into `reward_points` set `ACTIVE` = false

Save_Refund_Into_DB --> Initiate_All_Dwolla_Refunds : Success

Initiate_All_Dwolla_Refunds --> Update_Dwolla_External_ID : Success
Initiate_All_Dwolla_Refunds: call Dwolla API

Update_Dwolla_External_ID --> end 

Validate_Refund --> end : Not Validated
Save_Refund_Into_DB --> end : Failure
Initiate_All_Dwolla_Refunds --> end : Failure

state "Process Dwolla Webhook\n(async process)" as Process_Dwolla_Webhook {
  state start2  <<start>>
  state end2    <<end>>

  start2 --> Undo_Cancel_Redeemed_Reward_Points: if payment is Rejected \nand the original payment was specified
  Undo_Cancel_Redeemed_Reward_Points --> Undo_Mark_Original_Payment_As_Reverted
  
  Undo_Mark_Original_Payment_As_Reverted --> Undo_Mark_Reward_Points_As_Deactivated
  
  Undo_Mark_Reward_Points_As_Deactivated --> Update_Payment_Status
  Undo_Mark_Reward_Points_As_Deactivated : the reward points that have been\ncreated by original payment
  Undo_Mark_Reward_Points_As_Deactivated :  record into `reward_points` set `ACTIVE` = true
 
  
  start2 --> Update_Payment_Status: Any other cases
 
  Update_Payment_Status -->  Notify_Payment_Status_Subscribers
  Notify_Payment_Status_Subscribers --> end2
  
  
}


@enduml

```
