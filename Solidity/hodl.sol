pragma solidity ^0.4.16;

contract hodl{
	event Hodl(address indexed hodler, uint indexed amount);
	event Withdraw(address indexed hodler, uint indexed amount);
	event ReleaseBlocknumber(uint indexed blocknumber);
	mapping(address => uint) public hodlers;
	uint releaseBlocknumber;

	function hodl(uint waitNumberOfBlocks){
		releaseBlocknumber = block.number + waitNumberOfBlocks;
		ReleaseBlocknumber(releaseBlocknumber);
	}

	function() payable{
		hodlers[msg.sender] += msg.value;
		Hodl(msg.sender, msg.value);
	}

	function withdraw(){
		require(block.number > releaseBlocknumber && hodlers[msg.sender] > 0);
		uint value = hodlers[msg.sender];
		hodlers[msg.sender] = 0;
		msg.sender.transfer(value);
		Withdraw(msg.sender,value);
	}
}