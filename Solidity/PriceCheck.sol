pragma solidity ^0.4.16;

contract owned {
    address public owner;

    function owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
}


contract PriceCheck is owned{
	uint price = 1000000000000000000;

	uint checkedBlockNumber = block.number;

	mapping(address => uint) public balanceOf;
	mapping(address => bool) public hasPaid;
	mapping(address => uint) public blockNumberPaid;

	function PriceCheck() payable{
		//Check if the balance of the sender + the message value is less than 1 ether
		require(msg.value + balanceOf[msg.sender] <= price);
		//Add message value to balance
		balanceOf[msg.sender] += msg.value;
		_updatePayers();
	}

	function _updatePayers() internal {
		//If total balance equals 1 ether, sender has paid.
		if(balanceOf[msg.sender] == price && hasPaid[msg.sender] == false){
			hasPaid[msg.sender] = true;
			blockNumberPaid[msg.sender] = block.number;
			owner.transfer(balanceOf[msg.sender]);
		}else{
			hasPaid[msg.sender] = false;
		}
	}

	function pay(uint amount){
		if(amount == 1){
			hasPaid[msg.sender] = true;
		}
	}

	function removePayment(){
		hasPaid[msg.sender] = false;
	}

	function returnPaid() returns (bool){
		return hasPaid[msg.sender];
	}
}