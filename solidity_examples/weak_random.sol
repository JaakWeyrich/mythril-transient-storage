

contract WeakRandom {
    struct Contestant {
        address payable addr;
        uint gameId;
    }

    uint public prize = 2.5 ether;
    uint public totalTickets = 50;
    uint public pricePerTicket = prize / totalTickets;

    uint public gameId = 1;
    uint public nextTicket = 0;
    mapping (uint => Contestant) public contestants;

    receive() payable external {
        uint moneySent = msg.value;

        while (moneySent >= pricePerTicket && nextTicket < totalTickets) {
            uint currTicket = nextTicket++;
            contestants[currTicket] = Contestant(payable(msg.sender), gameId);
            moneySent -= pricePerTicket;
        }

        if (nextTicket == totalTickets) {
            chooseWinner();
        }

        // Send back leftover money
        if (moneySent > 0) {
            payable(msg.sender).transfer(moneySent);
        }
    }

    function chooseWinner() private {
        address seed1 = contestants[uint160(address(block.coinbase)) % totalTickets].addr;
        address seed2 = contestants[uint160(msg.sender) % totalTickets].addr;
        uint seed3 = block.difficulty;
        bytes32 randHash = keccak256(abi.encode(seed1, seed2, seed3));

        uint winningNumber = uint(randHash) % totalTickets;
        address payable winningAddress = contestants[winningNumber].addr;

        gameId++;
        nextTicket = 0;
        winningAddress.transfer(prize);
    }
}
