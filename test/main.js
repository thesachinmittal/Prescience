var Main = artifacts.require("Main");

contract("Main", function(accounts) {
  it("should assert true", function(done) {
    var main = Main.deployed();
    assert.isTrue(true);
    done();
  });
});
