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

contract lotto is owned{
	address[] ticketAddress = new address[](500);
	uint ticketPrice = 100000000000000000;
	uint public ticketsSold = 0;
	uint totalPricePool = 0;
	
// 	mapping(address => uint) public balanceOf;
	mapping(address => uint) public tickets;
	
	event TotalPricePool(uint indexed value);
	event Balance(address indexed participant, uint indexed entryAmount );
	event TotalTickets(address indexed participant, uint indexed totalTicketAmount);
	event TicketsCreated(uint indexed numberOfTickets);
	event Transfer(address indexed to, uint indexed value);
	
	function () public payable{
	    //User can't buy all tickets
	    require(msg.value < 5000000000000000000 && totalPricePool + msg.value < 6000000000000000000);
	    totalPricePool += msg.value;
// 		balanceOf[msg.sender] += msg.value;
// 		balance(msg.sender, msg.value);
		_createTickets();
		if(totalPricePool >= 5000000000000000000){
			_generateWinner();
		}
	}

	function _createTickets() internal{
		uint ticketAmount = msg.value / ticketPrice;
		TicketsCreated(ticketAmount);
		tickets[msg.sender] += ticketAmount;
		TotalTickets(msg.sender, ticketAmount);
		for(uint x = ticketsSold; x < ticketsSold + ticketAmount; x++){
            ticketAddress[x] = msg.sender;
		}	
		ticketsSold += ticketAmount;
	}

	function _generateWinner() internal{
		uint winningNumber = 2;
		ticketAddress[winningNumber].transfer(totalPricePool);
		totalPricePool = 0;
	}

	function clearPricePool() onlyOwner{
		Transfer(owner, totalPricePool);
		owner.transfer(totalPricePool);
		totalPricePool = 0;
		ticketsSold = 0;
	}

	// function _generateRandomNumber() internal{
	// 	nonce++;
 //        return uint(sha3(nonce))%(0+ticketAddress.length)-0;
 //    }

}