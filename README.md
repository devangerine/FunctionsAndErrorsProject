# FunctionsAndErrorsProject

This is a Solidity program that simulates a creditor loaning of wei to a debtor. The purpose of this program is showcase my current understanding of Solidity as a programming language (the usage of modifiers as well as error handling functions namely: require, assert, and revert) as well as serve as a referrence to those who are studying Solidity like me. 

## Description

This program is a contract written in Solidity, an object-oriented programming language typically used for developing smart contracts on various blockchain platforms such as ethereum. This contract has you act as a creditor giving a loans to debtors. The debtor pays for a transaction fee in this transaction. 

This contract has a modifier called onlyCreditor which only allows the creditor to access the contract's functions. This modifier to applied to all of the functions within this contract. The contract has the following functions: 
* sendLoan - sends a _loanAmount of type unsigned integer to a debtor associated with the user-inputted debtorId of type unsigned integer and sets that debtor's debtorOnCooldown status to true preventing that debtor from taking any more loans. 
* getCreditorBalance - returns the creditor's current balance. 
* getDebtorBalance - returns the balance of the debtor associated the user-inputted _debtorId of type unsigned integer. 
* debtorCooldownStatus - returns the cooldown of the debtor associated the user-inputted _debtorId of type unsigned integer.
* resetCooldown - sets the debtorOnCooldown status of the debtor associated with the user-inputted debtorId of type unsigned integer back to false thus allowing that debtor to take another loan.
* triggerAssert - increments the transactionFee state variable to trigger the assert statement that assumes it never changes to demonstrate the function of assert.
* viewTransactionFee - returns the current value of the state variable transactionFee.
* resetTransactionFee - sets the transactionFee back to its default value of 10.

This contract uses the following error handling functions:

* **require** - prevents any code below it if the conditional statement contained within the require function is not met. It has an optional message parameter to provide further context. Typically used for input validation.
* **assert** - similar to require it also contains a conditional statement within it but has no mmessage parameter and is typically used for debugging making sure that developer has not written code that changed something within the program that it should not have. If an assert is triggered a revert will occur which reverses any changes done to the state of the contract.
* **revert** - reverses any changes done to the state of the contract. Typically contained within a conditional statement and if the conditonal statement returns true, the revert statement is triggered. 

## Getting Started

### Executing program

In order to run this program, you can use Remix, an online Solidity IDE which I used to develop this contract. For starters, please go to the Remix website at https://remix.ethereum.org/.
Upon reaching the website, create a new file by clicking the "New File" button around the center of the website or the button that looks like a piece of paper with the top right corner folded found on the top left corner of the website under workspaces. Save the file under the file name of your choice while making sure to use the .sol extension (e.g. ErrorHandling.sol). Copy and then paste the following code into the file you have just created:


```Solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract FunctionsAndErrors{

  address creditor;
 
  uint creditorBalance = 1000; //Simulated creditor balance in wei
  uint[] debtorBalance = [200,0]; //Simulated debtor balance in wei
  uint transactionFee = 10; // Simulated transaction fee in wei
  
  //Checks if there is an ongoing transaction assuming we are limited to one at a time
  bool[] debtorOnCooldown = [false,false];
  
  //Constructor sets the address of msg.sender to creditor for the purposes of this demonstration 
  constructor(){
    creditor = msg.sender;
  }

  //Creation of onlyCreditor modifier
  modifier onlyCreditor{

    require(creditor == msg.sender, "Only the creditor can access this function");
    _;

  }

  //Function to get the balance of the creditor's account. 
  /*The function getCreditorBalance() will not return the balance 
  if you use a different address from the one initialized in the constructor.*/
  function getCreditorBalance() public view onlyCreditor returns(uint){

    return creditorBalance;

  }

  //Function to get the balance of the debtor's account. This is not secure and is just for testing purposes. 
  function getDebtorBalance(uint _debtorId) public view onlyCreditor returns(uint){
    require(_debtorId == 0 || _debtorId == 1,"Invalid debtor ID");
    return debtorBalance[_debtorId];

  }

  /*Function to send the loan amount to the debtor.
    Asserts that the transaction fee is 10 because that value has no way to be updated in this contract except
    for triggerAssert() which exists for testing purposes.
    For each transaction the debtor must pay a simulated 10 wei fee.
    Only the creditor can access this function.
    Requires that the debtor is not on cooldown.
    Will revert if either the creditor's balance or the debtor's balance is insufficient.*/
  function sendLoan(uint _loanAmount, uint _debtorId) public payable onlyCreditor{
    assert(transactionFee == 10);
    require(_debtorId == 0 || _debtorId == 1,"Invalid debtor ID");
    require(debtorOnCooldown[_debtorId] == false,"Debtor on transaction cooldown cannot receive any loans");

    debtorOnCooldown[_debtorId] = true;
    
    if(creditorBalance < _loanAmount)
        revert("Creditor Balance is insufficient to continue with this transaction.");

    if(debtorBalance[_debtorId] < transactionFee)
        revert("Debtor Balance is insufficient to continue with this transaction.");

    creditorBalance -= _loanAmount;
    debtorBalance[_debtorId] += _loanAmount-transactionFee;

  }

  //Function to check the status of the debtor if they are on cooldown from receiving any more loans.
  function debtorCooldownStatus(uint _debtorId) public view onlyCreditor returns(bool){
    require(_debtorId == 0 || _debtorId == 1,"Invalid debtor ID");
    return debtorOnCooldown[_debtorId];
  }

  //Function to set the debtorOnCooldown of the debtor associated with the provided _debtorId to false.
  //This function will enable the debtor associated with the provided _debtorId to be able to receive another loan.
  function resetCooldown(uint _debtorId) public onlyCreditor{
    require(_debtorId == 0 || _debtorId == 1,"Invalid debtor ID");
    debtorOnCooldown[_debtorId] = false;

  }


  //Changes the value of transactionFee to trigger the assertion found in sendLoan()
  function triggerAssert() public onlyCreditor{
    transactionFee++;

    
  }

  //Function to show the current value of transactionFee
  function viewTransactionFee() public view onlyCreditor returns(uint){
    return transactionFee;
  }
  
}


```
### Contract Compilation
In order to compile the code, click on the "Solidity compiler" tab found in the left-hand sidebar below the button that looks like a magnifying glass. Please make sure the Compiler is set to "0.8.18" (or any other compatible version), and then click on the "Compile ErrorHandling.sol" assuming you named your Solidity contract as such. Otherwise, the button will say "Compile " followed by the name of your Solidity contract. For simplicity's sake I will be referring to the contract you have made as "ErrorHandling.sol" but it will appear on the Remix IDE as how you named the contract.


### Contract Deployment
After the contract has been compiled, you can now deploy the contract by clicking on the "Deploy & run transactions" tab found in the left-hand sidebar below the "Solidity compiler" tab. Select the "ErrorHandling.sol" contract or as how you have named it. After selecting the contract, click on the "Deploy" button.


### Post Contract Deployment
After the contract has been deployed, the contract will be found under "Deployed Contracts". Expand it by clicking the ">" button below "Deployed Contracts". You should see the following buttons: 
* sendLoan - sends a _loanAmount of type unsigned integer to a debtor associated with the user-inputted debtorId of type unsigned integer and sets that debtor's debtorOnCooldown status to true preventing that debtor from receiving any more loans. 
* getCreditorBalance - returns the creditor's current balance. 
* getDebtorBalance - returns the balance of the debtor associated the user-inputted _debtorId of type unsigned integer. 
* debtorCooldownStatus - returns the cooldown of the debtor associated the user-inputted _debtorId of type unsigned integer.
* resetCooldown - sets the debtorOnCooldown status of the debtor associated with the user-inputted _debtorId of type unsigned integer back to false thus allowing that debtor to take another loan.
* triggerAssert - increments the transactionFee state variable to trigger the assert statement that assumes it never changes to demonstrate the function of assert.
* viewTransactionFee - returns the current value of the state variable transactionFee.

These buttons correspond to each of the functions within the contract.
The sendLoan, getDebtorBalance, debtorCooldownStatus, and resetCooldown have input fields beside them.

You can interact with contract with the following actions:

#### I - Getting the balance of the creditor

**Steps on getting the balance of the creditor:**

1.) Find the "getCreditorBalance" button.

2.) Click the "getCreditorBalance" button. The current balance of the creditor will be shown below the button.

#### II - Getting the balance of the debtor

Note: getDebtorBalance has the following error handling:

* A require that the _debtorId parameter be only either equal to 0 or 1 because I limited the number of possible debtors to keep this contract as simple as possible. 

**Steps on getting the balance of the debtor:**

1.) Find the input field beside the "getDebtorBalance" button.

2.) Input a _debtorId in that input field. The _debtorId must only be either a 0 or a 1. (Refer to the error handling list of this function found above.)

3.) Click the "getCreditorBalance" button. The current balance of the creditor will be shown below the button.

#### III - Getting the debtorOnCooldown status of a debtor

Note: debtorOnCooldown has the following error handling:

* A require that the _debtorId parameter be only either equal to 0 or 1 because I limited the number of possible debtors to keep this contract as simple as possible. 

**Steps on getting the debtorOnCooldown status of a debtor:**

1.) Find the input field beside the "debtorOnCooldown" button.

2.) Input a _debtorId in that input field. The _debtorId must only be either a 0 or a 1. (Refer to the error handling list of this function found above.)

3.) Click the "debtorOnCooldown" button. The current debtorOnCooldown status of the debtor associated with the _debtorId you provided will be displayed below. It will be false if the debtor is not cooldown
otherwise true if the debtor is on cooldown and cannot take a loan.

#### IV - Sending a loan
Note: sendLoan has the following error handling:

* An assertion that the transactionFee(state variable of type unsigned integer) is always 10 because under normal operation of the contract the transactionFee does not get changed but the triggerAssert function exists to increment the transactionFee in order to demonstate how assert works which is to throw an error and revert any changes to the state of the contract done before the assertion is executed. 

* A require that the _debtorId parameter be only either equal to 0 or 1 because I limited the number of possible debtors to keep this contract as simple as possible.  

* A require that the debtorOnCooldown element assocaited with the _debtorId is false which means that the debtor associated with the _debtorId not on loaning cooldown as a result of taking a loan recently.

* A revert that gets triggered when the if statement that checks if the creditor's balance is less then the _loanAmount returns true. 

* A revert that gets triggered when the if statement that checks if the debtor's balance is less than the transactionFee returns true.

**Steps on sending a loan:**

**Note: The _debtorId with the value of 1 has 0 balance and will always trigger the revert within tge condtional statement checking that the debtor's balance is greater than the transactionFee.**

1.) Find the input field beside the "sendLoan" button.

2.) Click the input field beside the "sendLoan" button and input a _loanAmount and a _debtorId seprated by a comma (e.g. 60, 0). The _debtorId must only be either a 0 or a 1.

3.) Click the  the "sendLoan" button to send the _loanAmount to the debtor assocaited with the _debtorId you provided. This will fail if debtor's debtorOnCooldown status is true or both/either the debtor and/or the creditor do not have enough balance for the transaction otherwise the loan will be sent successfully.(Refer to the error handling list of this function found above.) You can verify that the loan was sent by clicking the "getCreditorBalance" button and the "getDebtorBalance" button. Use the _debtorId you used here in "sendLoan" as your input for "getDebtorbalance". After the transaction the debtor assocaited with the _debtorId will be put on coolddown and receive loans unless you reset that cooldown more on that later. 

#### V - Using resetCooldown to reset the debtorOnCooldown status of a debtor

Note: debtorOnCooldownStatus has the following error handling:

* A require that the _debtorId parameter be only either equal to 0 or 1 because I limited the number of possible debtors to keep this contract as simple as possible. 

**Steps on Using resetCooldown to reset the debtorOnCooldown status of a debtor:**

1.) Find the "resetCooldown" button.

2.) Input a _debtorId in that input field. The _debtorId must only be either a 0 or a 1. (Refer to the error handling list of this function found above.)

3.) Click the "resetCooldown" button. The current debtorOnCooldown status of the debtor associated with the _debtorId you provided will be set to false thus allow the debtor to receive a loan. You can verify this change by using the debtorOnCooldown function making sure to input the same _debtorId you inputed in resetCooldown to debtorOnCooldown.

#### VI - Getting the value of the transactionFee using viewTransactionFee

**Steps on getting the value of the transactionFee:**

1.) Find the "viewTransactionFee" button.

2.) Click the "viewTransactionFee" button. The value of the transactionFee will be found below the button. It should display 10 if the triggerAssert function has not been used.

#### VII - Using triggerAssert

The sendLoan function has an assertion that the transactionFee(state variable of type unsigned integer) is always 10 because under normal operation of the contract the transactionFee does not get changed but the triggerAssert function exists to increment the transactionFee in order to demonstate how assert works which is to throw an error and revert any changes to the state of the contract done before the assertion is executed.  

In this case, we will be intentionally triggering it through the use of triggerAssert.

**Steps on getting the value of the transactionFee:**

1.) Find the "triggerAssert" button.

2.) Click the "triggerAssert" button. The value of the transactionFee will be incremented by 1. You can verify the change to the transactionFee variable by clicking the viewTransactionFee button.

3.) Try sending a loan. (Refer to the instructions on how to send a loan found in the IV - Sending a loan section of this readme file.) It should fail and throw an error.

#### VII - Using resetTransactionFee to reset the transactionFee to it's default value of 10

1.) Find the "resetTransactionFee" button.

2.) Click the "triggerAssert" button. The value of the transactionFee will set to it's default value of 10. You can verify the change to the transactionFee variable by clicking the viewTransactionFee button.

3.) Try sending a loan. (Refer to the instructions on how to send a loan found in the IV - Sending a loan section of this readme file.) It should succeed and throw no errors. You can verify this by viewing the balances of the creditor and the debtor you send the loan to by using getCreditorBalance and getDebtorBalance respectively. 

## Code explanation and Contract usage Video Walkthrough
Below is the video walkthrough on how to use the contract once you already have it compiled and deployed on the Remix IDE:
https://www.loom.com/share/729d20832a7b4f1c824a6c1f79662c21


## Help

### Compilation failed
Please check if the code inside the .sol file you created in remix matches the code I provided. If it does not match then please copy the code I provided in its entirety and replace the code in the .sol filed that you created in Remix. If it does match and it still will not compile then please check your internet connection or trying a different browser or updating your current browser. 

### Debtor balance did not increase/Creditor balance did not dencrease after sending loan
Please make sure that the _debtorId you provided in the input field beside the "sendLoan" button matches the address you provided the input field beside the "getDebtorBalance" button. If both matches there may have been another error such as: 

The transaction itself failed due to either the debtor being on cooldown.

The creditor does not have enough balance for the transaction.

The debtor does not have enough balance for the transaction.

If the above does not help or cover the issue you are having with regards to this Solidity Contract I made then please feel free to reach me at 201812805@fit.edu.ph or voltairedvx@gmail.com and I will try to help you as soon as I can.


## Authors

Drennix Guerrero @ 201812805@fit.edu.ph

## License

This project is licensed under the MIT License - see the LICENSE.md file for details
