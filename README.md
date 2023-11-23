# FunctionsAndErrorsProject

This is a Solidity program that simulates a creditor loaning of wei to a debtor. The purpose of this program is showcase my current understanding of Solidity as a programming language (the usage of modifiers as well as error handling functions namely: require, assert, and revert) as well as serve as a referrence to those who are studying Solidity like me. 

## Description

This program is a contract written in Solidity, an object-oriented programming language typically used for developing smart contracts on various blockchain platforms such as ethereum. This contract has you act as a creditor giving a loans to debtors. The debtor pays for a transaction fee in this transaction. 

This contract has a modifier called onlyCreditor which only allows the creditor to access the contract's functions. This modifier to applied to all of the functions within this contract. The contract has the following functions: 
* sendLoan - sends a loan amount to a debtor associated with the provided debtorId and sets that debtor's debtorOnCooldown status to true preventing that debtor from taking any more loans. 
* getCreditorBalance - returns the creditor's current balance. 
* getDebtorBalance - returns the balance of the debtor associated the provided _debtorId. 
* debtorCooldownStatus - returns the cooldown of the debtor associated the provided _debtorId.
* resetCooldown - sets the debtorOnCooldown status of the debtor associated with the provided debtorId back to false thus allowing that debtor to take another loan.
* triggerAssert - increments the transactionFee state variable to trigger the assert statement that assumes it never changes to demonstrate the function of assert.
* viewTransactionFee - returns the current value of the state variable transactionFee.

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
After the contract has been deployed, the contract will be found under "Deployed Contracts". Expand it by clicking the ">" button below "Deployed Contracts". You should see the following buttons: "burnToken", "mintToken", "balances", "tokenAbbreviation", "tokenName", and "totalSupply". The "burnToken" and "mintTokem" buttons have input fields beside each button. These input fields accepts an address and a positive integer value as parameters/input strictly in that order. The aforementioned parameters/input are separated by a comma (e.g. 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,1000). You can get an address by clicking the "Copy account to clipboard" button which looks like two pieces of paper stacked on the of each other with the upper right corner folded. This button is found below "Account" and beside the current selected Account/Address. After clicking the "Copy account to clipboard" button you can now paste it inside the input fields beside the following buttons: "burnToken", "mintToken", or "balances". The input field beside the "balances" button only accepts an address as parameter/input. Note: The address you will be using can vary from my example. 


You can interact with contract with the following actions:

#### I - Token Information, Supply Count, and Balances
1.) Click the "tokenName" button to view the name of the token.

2.) Click the "tokenAbbreviation" button to view the abbreviation of the token.

3.) Click the "totalSupply" button to view the total supply of tokens that have been minted. (This will display 0 below it if you have not minted any tokens or burned all of your tokens)

4.) Copy an address and paste it inside the input field beside the "balances" button. (Please read the "Post Contract Deployment" section of this README.md for instructions on how to find and copy an address) After pasting the address inside the input field, click the "balances" button to view the balance of the account/address you provided.

#### II - Minting of Tokens

1.) Copy an address and paste it inside the input field beside the "mintToken" button. (Please read the "Post Contract Deployment" section of this README.md for instructions on how to find and copy an address) type a comma (,) after the address you just pasted and type a positive integer beside it. (e.g. 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,1000). Once the input field beside the "mintToken" button has been filled like in the example shown before, click the "mintToken" button to mint tokens.

2.) Click on the "totalSupply" button to confirm that the total supply of minted tokens have increased accordingly. 

3.) Click the input field beside the "balances" button and paste the same address you used in the input field beside the "mintToken" button. (e.g. 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4). Afterwards click the "balances" button to confirm that the balance of that address you provided has increased accordingly. If the balance did not increase please make sure that the address you provided matches the address you provided in the input field beside the "mintToken" button. 

#### III - Burning of Tokens

#### Note: You can attempt to burn tokens even while having zero(0) balance or a balance below the inputted amount of tokens to be burned. The transaction will proceed but no burning of tokens will occur because of the balance check if statement found in the burnToken function of the code I provided that does not allow the burning of tokens to occur when the balance of the provided address/account is zero(0) or below the inputted amount of tokens to be burned. 

 1.) Copy an address and paste it inside the input field beside the "burnToken" button. (Please read the "Post Contract Deployment" section of this README.md for instructions on how to find and copy an address) type a comma (,) after the address you just pasted and type a positive integer beside it. (e.g. 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,1000). Once the input field beside the "burnToken" button has been filled like in the example shown before, click the "burnToken" button to burn tokens. 

 2.) Click on the "totalSupply" button to confirm that the total supply of minted tokens have deccreased accordingly. If the total supply did not decrease please see the Note of the "Burning of Tokens" section of this README.md.


 3.) Click the input field beside the "balances" button and paste the same address you used in the input field beside the "mintToken" button. (e.g. 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4). Afterwards click the "balances" button to confirm that the balance of that address you provided has increased accordingly. If the balance of the provided address did not decrease accordingly, please make sure that the address you provided is the matches the address you provided in the input field beside the "burnToken" button. Otherwise, after you have made sure that the two addressess match then please read the Note of the "Burning of Tokens" section of this README.md. 

## Code explanation and Contract usage Video Walkthrough
Below is the video walkthrough on how to use the contract once you already have it compiled and deployed on the Remix IDE:
https://www.loom.com/share/41c78dc255a248d9900d4844c239665a


## Help

### Compilation failed
Please check if the code inside the .sol file you created in remix matches the code I provided. If it does not match then please copy the code I provided in its entirety and replace the code in the .sol filed that you created in Remix. If it does match and it still will not compile then please check your internet connection or trying a different browser or updating your current browser. 

### Balance did not increase after minting tokens
Please make sure that the address you provided in the inpute field beside the "balances" button matches the address you provided the input field beside the "mintToken" button.

### Balance did not dencrease after burning tokens
Please make sure that the address you provided in the inpute field beside the "balances" button matches the address you provided the input field beside the "burnToken" button. If they match then please read the Note of the "Burning of Tokens" section. Burning of tokens cannot occur when the balance is zero(0) or below the amount of tokens to be burned.

### Total supply did not decrease after burning tokens
Burning of tokens cannot occur when the balance is zero(0) or below the amount of tokens to be burned. Please read the Note of the "Burning of Tokens" section for more information.

If the above does not help or cover the issue you are having with regards to this Solidity Contract I made then please feel free to reach me at 201812805@fit.edu.ph or voltairedvx@gmail.com and I will try to help you as soon as I can.


## Authors

Drennix Guerrero @ 201812805@fit.edu.ph

## License

This project is licensed under the MIT License - see the LICENSE.md file for details

The function **sendLoan** is the primary function of this contract. This function accepts a _loanAmount and a _debtorId(both of which are local variables of type unsigned integer) as paramaters and has the following error handling:

* An assertion that the transactionFee(state variable of type unsigned integer) is always 10 because under normal operation of the contract the transactionFee does not get changed but the triggerAssert function exists to increment the transactionFee in order to demonstate how assert works which is to throw an error and revert any changes to the state of the contract done before the assertion is executed. 

* A require that the _debtorId parameter be only either equal to 0 or 1 because I limited the number of possible debtors to keep this contract as simple as possible.   

* A revert that gets triggered when the if statement that checks if the creditor's balance is less then the _loanAmount returns true. 

* A revert that gets triggered when the if statement that checks if the debtor's balance is less than the transactionFee returns true.

The function getCreditorBalance returns the current balance of the creditor. 

