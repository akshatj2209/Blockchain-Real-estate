pragma solidity >=0.4.16 <0.9.0;

contract Property{
    string addressOfProperty;
    address payable owner;
    address payable interested;
    string id;
    uint Pincode;
    
    struct PropertyPapers{
        uint houseNumber;
        uint RegistrationNumber;
    }
    
    enum StateOfHouse{
        Unintended,
        ForSale,
        DealPending,
        NegotiationSuccessFul,
        PaymentDone,
        TransferSuccessful
    }
    
    StateOfHouse state;
    
    mapping (address => string) request;
    mapping (address => uint) price;
    
    uint priceFinal; 
    
    PropertyPapers papers;

    modifier ForOwnerFunctions(){
        require( msg.sender == owner
        ,"You are Not The Owner Man, How are you trying to Do this thing, Just Go Away");
        _;
    }

    constructor (string memory idOfProperty , string memory addOfProperty  , uint regnr , uint housern , uint postalCode) public {
        owner = payable(msg.sender);
        papers= PropertyPapers(housern, regnr);
        addressOfProperty = addOfProperty;
        Pincode = postalCode;
        id = idOfProperty;
        state =  StateOfHouse.Unintended;
    }
    
    function getOwner() public view returns(address){
        return owner;
    }
    
    function setForSale() public ForOwnerFunctions(){
        state =  StateOfHouse.ForSale;
    }
    
    function sendRequest(string memory message, uint dealprice) public {
        require(state == StateOfHouse.ForSale,
        "You cannot do this deal sorry it is not for sale currently");
        request[owner] = message;
        price[owner] = dealprice;
        state=StateOfHouse.DealPending;
        interested = payable( msg.sender);
    } 
    function readRequest() public ForOwnerFunctions() view returns (string memory){
        return request[msg.sender];
    }
    function readPrice() public ForOwnerFunctions() view returns (uint){
        return price[msg.sender];
    }
    
    function doneDeal() public ForOwnerFunctions() {
        state=StateOfHouse.NegotiationSuccessFul;
        priceFinal = price[msg.sender];
        request[interested] = "I accept the deal! Payment Due!";
    }
    
    function dealConditions() public view returns(string memory){
        require(state == StateOfHouse.NegotiationSuccessFul,
        "Not yet Finalised!");
        return request[interested];
    }
    
    function doPayment() public {
        address payable _owner = owner;
        _owner.send(priceFinal);
        state = StateOfHouse.PaymentDone;
        owner = payable(interested);
        state = StateOfHouse.TransferSuccessful;
    }
    
    
}