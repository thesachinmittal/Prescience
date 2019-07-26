import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SupportLib.sol";

contract SupportLib{
    SupportLib support = SupportLib(DeployedAddresses.SupportLib());
    function testBoolMaxRightSide() public{
    uint returnResult = support.boolMax(60,50);

    uint expected = 1;

    Assert.equal(returnResult, expected, "Winner should be first one");
  }

    function testBoolMaxLeftSide() public{
        uint returnResult = support.boolMax(50,60);

        uint expected = 0;
     Assert.equal(returnResult, expected, "Winner Should be the second one");
    }

    // function testBoolMaxEqual() pulbic{
    //     uint returnResult = support.boolMax(50,50);

    //     uint expected = ERROR;
    //  Assert.
    // }

    function testEncryption() public{
        bytes32 returnResult = support.encryption("testing");

        bytes32 expected= "0x";             // SHA256 Hash of abi.encoded string("testing")
        Assert.equal(returnResult,expected, "The hashing should be same" );
    }

    // MetaCoin meta = new MetaCoin();

    // uint expected = 10000;

    // Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 MetaCoin initially");
}
