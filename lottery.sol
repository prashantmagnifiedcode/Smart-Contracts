// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;
contract lottery{
    address public manager;
    address payable[] public player;
    constructor (){
        manager= msg.sender;
    }
    function alreadyentered() view private returns(bool){
        for(uint i=0;i<player.length;i++){
            if(player[i]==msg.sender){
                return true;
            }
        }
        return false;
    }
    function enter() payable public{
        require(msg.sender!= manager,"manager can not enter");
        require(alreadyentered() == false,"player already entered");
        require(msg.value>1,"minimum 1 ether required");
        player.push(payable(msg.sender));
    }
    function random() view private returns(uint){
       return  uint(sha256(abi.encodePacked(block.difficulty,block.number,player)));
    }
    function picker() public{
        require(msg.sender==manager,"only manager pick the winner");
        uint index=random()%player.length;
        address contractaddres= address(this);
        player[index].transfer(contractaddres.balance);
    }
}