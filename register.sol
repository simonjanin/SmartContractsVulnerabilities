contract register {
    mapping(bytes32 => address) domains; // we map hashes to addresses
    
    function register_name(string name) {
        if (domains[sha3(name)] != 0)
            throw; // domain already registered
        else
            domains[sha3(name)] = msg.sender; // register domain name to msg.sender's name
    }
    
}