var JLToken = artifacts.require("JLToken.js");

module.exports = function(deployer){
    deployer.deploy(JLToken, 10000);
};