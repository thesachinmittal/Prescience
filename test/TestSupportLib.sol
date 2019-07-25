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

    function testEncryption() public{
        bytes32 returnResult = support.encryption("testing");
        
        bytes32 = ""
    }

    // MetaCoin meta = new MetaCoin();

    // uint expected = 10000;

    // Assert.equal(meta.getBalance(tx.origin), expected, "Owner should have 10000 MetaCoin initially");
}
