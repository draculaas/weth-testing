// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract WETH {
    string public name = "Wrapped Ether";
    string public symbol = "WETH";
    uint8 public decimals = 18;

    event Approval(address indexed src, address indexed guy, uint256 wad);
    event Transfer(address indexed src, address indexed dst, uint256 wad);
    event Deposit(address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;


    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 wad) public {
        require(balanceOf[msg.sender] >= wad, "invalid balance");
        balanceOf[msg.sender] -= wad;
        payable(msg.sender).transfer(wad);
        emit Withdrawal(msg.sender, wad);
    }

    function totalSupply() public view returns (uint256) {
        return address(this).balance;
    }

    function approve(address to, uint256 value) public returns (bool) {
        allowance[msg.sender][to] = value;
        emit Approval(msg.sender, to, value);
        return true;
    }

    function transfer(address dst, uint256 value) public returns (bool) {
        return transferFrom(msg.sender, dst, value);
    }

    function transferFrom(address src, address dst, uint256 value) public returns (bool) {
        require(balanceOf[src] >= value);
        
        if (src != msg.sender && allowance[src][msg.sender] != type(uint256).max) {
            require(allowance[src][msg.sender] >= value);
            allowance[src][msg.sender] -= value;
        }

        balanceOf[src] -= value;
        balanceOf[dst] += value;

        emit Transfer(src, dst, value);
        return true;
    }
}
