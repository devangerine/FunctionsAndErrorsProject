# FunctionsAndErrorsProject

This is a Solidity program that simulates a creditor loaning of wei to a debtor. The purpose of this program is showcase my current understanding of Solidity as a programming language (the usage of modifiers as well as error handling functions namely: require, assert, and revert) as well as serve as a referrence to those who are studying Solidity like me.

## Description

This program is a contract written in Solidity, an object-oriented programming language typically used for developing smart contracts on various blockchain platforms such as ethereum. This contract has you act as a creditor giving a loans to debtors. The debtor pays for a transaction fee in this scenario. 

This contract has a modifier called onlyCreditor which only allows the creditor to access the contract's functions and this modifier to applied to all of the functions within this contract. The contract has the following functions: sendLoan, getCreditorBalance, getDebtorBalance, debtorCooldownStatus, resetCooldown, triggerAssert, and viewTransactionFee. 

The function sendLoan is the primary function of this contract. The function accepts a _loanAmount and a _debtorId(both of which are local variables of type unsigned integer)as paramaters. The function has the following error handling:
 
*An assertion that the transactionFee(state variable of type unsigned integer) is always 10 because under normal operation of the contract the transactionFee does not get changed but the triggerAssert function exists to increment the transactionFee in order to demonstate how assert works which is to throw an error and revert any changes to the state of the contract done before the assertion is executed. 

*A require that the _debtorId parameter be only either equal to 0 or 1 because I limited the number of possible debtors to keep this contract as simple as possible.

*A revert that gets triggered when the if statement that checks if the creditor's balance is less then the _loanAmount returns true. 

*A revert that gets triggered when the if statement that checks if the debtor's balance is less than the transactionFee returns true.




## Getting Started

### Executing program

In order to run this program, you can use Remix, an online Solidity IDE which I used to develop this contract. For starters, please go to the Remix website at https://remix.ethereum.org/.
Upon reaching the website, create a new file by clicking the "New File" button around the center of the website or the button that looks like a piece of paper with the top right corner folded found on the top left corner of the website under workspaces. Save the file under the file name of your choice while making sure to use the .sol extension (e.g. MyFirstProgram.sol). Copy and then paste the following code into the file you have just created:


```Solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

/*
       REQUIREMENTS
    1. Your contract will have public variables that store the details about your coin (Token Name, Token Abbrv., Total Supply)
    2. Your contract will have a mapping of addresses to balances (address => uint)
    3. You will have a mint function that takes two parameters: an address and a value. 
       The function then increases the total supply by that number and increases the balance 
       of the “sender” address by that amount
    4. Your contract will have a burn function, which works the opposite of the mint function, as it will destroy tokens. 
       It will take an address and value just like the mint functions. It will then deduct the value from the total supply 
       and from the balance of the “sender”.
    5. Lastly, your burn function should have conditionals to make sure the balance of "sender" is greater than or equal 
       to the amount that is supposed to be burned.
*/

contract MyToken {

    // public variables here
    string public tokenName = "Banana";
    string public tokenAbbreviation = "BNN";
    uint public totalSupply = 0;

    // mapping variable here
    mapping(address => uint) public balances;

    // mint function
    function mintToken(address _address, uint _value) public{
        totalSupply += _value;
        balances[_address] += _value;
    }

    // burn function
    function burnToken(address _address, uint _value) public{
        
        //If statement to make sure that the provided address's balance is sufficient before burning token
        if(balances[_address] >= _value){
            totalSupply -= _value;
            balances[_address] -= _value;
        }
    }
}

```
### Contract Compilation
In order to compile the code, click on the "Solidity compiler" tab found in the left-hand sidebar below the button that looks like a magnifying glass. Please make sure the "Compiler is set to "0.8.18" (or any other compatible version), and then click on the "Compile MyFirstProgram.sol" assuming you named your Solidity contract as such. Otherwise, the button will say "Compile " followed by the name of your Solidity contract. For simplicity's sake I will be referring to the contract you have made as "MyFirstProgram.sol" but it will appear on the Remix IDE as how you named the contract.


### Contract Deployment
After the contract has been compiled, you can now deploy the contract by clicking on the "Deploy & run transactions" tab found in the left-hand sidebar below the "Solidity compiler" tab. Select the "MyFirstProgram.sol" contract or as how you have named it. After selecting the contract, click on the "Deploy" button.


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
