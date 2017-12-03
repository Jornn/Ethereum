pragma solidity ^0.4.15;

contract owned{
	address public owner;

	function owned(){
		owner = msg.sender;
	}

	modifier onlyOwner{
		require(msg.sender == owner);
		_;
	}

	function transferOwnership(address newOwner){
		owner = newOwner;
	}
}

contract MyToken is owned {
    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    mapping(address => bool) public frozenAccount;

	event Transfer(address indexed from, address indexed to, uint256 value);
	event FrozenFunds(address target, bool frozen);
    // event Buy(uint amount);

    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    uint public buyPrice;

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function MyToken(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits, uint setBuyPrice) {
        name = tokenName;
        symbol = tokenSymbol;
        decimals = decimalUnits;
        totalSupply = initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
        buyPrice = setBuyPrice * 10 finney;
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) {
        _transfer(msg.sender, _to, _value);
    }

    function _transfer(address _from, address _to, uint _value) internal returns(bool success) {
        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
        require (balanceOf[_from] > _value);                // Check if the sender has enough
        require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
        require(!frozenAccount[_from]);                     // Check if sender is frozen
        require(!frozenAccount[_to]);                       // Check if recipient is frozen
        balanceOf[_from] -= _value;                         // Subtract from the sender
        balanceOf[_to] += _value;                           // Add the same to the recipient
        Transfer(_from, _to, _value);
        return true; //test
    }

    function mintToken(address target, uint256 mintedAmount) onlyOwner{
    	balanceOf[target] += mintedAmount * 10 ** uint256(decimals);
    	totalSupply += mintedAmount * 10 ** uint256(decimals);
    	Transfer(owner, target, mintedAmount);
    }

    function freezeAccount(address target, bool freeze) onlyOwner{
    	frozenAccount[target] = freeze;
    	FrozenFunds(target, freeze);
    }

    function setPrices(uint newBuyPrice) onlyOwner{
        buyPrice = newBuyPrice * 10 finney;
    }

    function buy() payable returns (uint amount){
        amount = msg.value / buyPrice;
        require(balanceOf[this] >= amount);
        balanceOf[msg.sender] += amount;
        balanceOf[this] -= amount;
        Transfer(this, msg.sender, amount);
        // Buy(uint amount);
        return amount;
    }
}