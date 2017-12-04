pragma solidity ^0.4.16;

contract setName{

	string public name;
	uint public age;

	event ChangePerson(string indexed Name, uint indexed Age);

	function setName(string _name, uint _age){
		name = _name;
		age = _age;
	}

	function changePerson(string _name, uint _age){
		name = _name;
		age = _age;
		ChangePerson(name, age);
	}

	function getPerson() public returns(string, uint){
		return(name, age);
	}
}