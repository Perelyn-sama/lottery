// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

contract Lottery is ReentrancyGuard {
    mapping(address => uint256) public guesses;
    uint256 public fee = 1 ether;
    address[] public players;
    address[] public winners;
    mapping(address => bool) public canWithdraw;

    constructor() payable {}

    modifier onlyWinner() {
        require(canWithdraw[msg.sender] == true);
        _;
    }

    function takeAGuess(uint256 guess) public payable {
        require(guess <= 20, "Guess between 1 - 20");
        require(msg.value == fee, "Not enough funds to take a guess");
        require(guesses[msg.sender] == 0, "Already took a guess");
        require(address(this).balance <= 3 ether, "maximum guesses");
        guesses[msg.sender] = guess;
        players.push(msg.sender);
    }

    function contractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function check() public {
        require(address(this).balance >= 3 ether, "Game not yet over");
        uint256 num = 5;
        for (uint256 i = 0; i < 3; i++) {
            if (guesses[players[i]] == num) {
                winners.push(players[i]);
                canWithdraw[players[i]] = true;
            }
        }
    }

    function withdraw() public onlyWinner nonReentrant {
        uint256 bal = address(this).balance;
        uint256 share = bal / winners.length;
        for (uint256 i = 0; i < winners.length; i++) {
            address payable x = payable(winners[i]);
            _withdraw(x, share);
        }
    }

    function _withdraw(address _address, uint256 _amount) internal {
        (bool success, ) = _address.call{value: _amount}("");
        require(success, "WITHDRAW: Transfer failed.");
    }

    function balanceOf(address acct) public view returns (uint256) {
        return acct.balance;
    }
}
