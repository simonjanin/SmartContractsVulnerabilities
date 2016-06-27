contract register2 {
    // the commitment scheme is: H(name + address + nonce + blocknumber)
    // <!> shift attacks! (use sha3 everywhere??)
    // assumptions:
    // (1) block.number == 0 is NOT possible
    // (2) SHA3 is collision free (at least computationally)
    
    struct Ownership {
        address owner;
        bytes32 commitment;
        bytes32 nonce;
        uint blockNumber;
    }
    
    
    mapping(bytes32 => uint) commitments; // we map commitments to block numbers
    mapping(bytes32 => Ownership) domains; // we map hashes to addresses
    

    function register_commitment(bytes32 commitment) {
        if (commitments[commitment] == 0) { // we assume block 0 isn't a reachable state; see assumption (1)
            commitments[commitment] = block.number; // we don't care who does the commitment, it only matters for the reveal' part
        } else {
            throw; // it has already been committed
        }
    }
    
    function register_reveal(bytes32 commitment, string name, bytes32 nonce) {
        if (commitments[commitment] > 0 && commitments[commitment] < block.number) {
            // we check that the commitment is already there and happened before this block
            // this function should NOT be called before the commitment is verifiably present on the main chain (possibly 5 verifications)
            
            if (domains[sha3(name)].Ownership.blockNumber != 0 && domains[sha3(name)].Ownership.blockNumber > commitments[commitment]) {
                // if the actual commitment is older, we overide the Ownership information
                
                if (sha3(name + msg.sender + nonce) == commitment) {
                    // we first make sure that the commitment is valid
                    
                    domains[sha3(name)].Ownership.owner = msg.sender;
                    domains[sha3(name)].Ownership.nonce = msg.nonce;
                    domains[sha3(name)].Ownership.blockNumber = commitments[commitment];
                }
            }
        }
    }
    
}