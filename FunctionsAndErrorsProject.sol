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
  
  //Function to set the transactionFee state variable back to it's default value of 10
  function resetTransactionFee() public onlyCreditor{
    transactionFee = 10;
  }
  
}
