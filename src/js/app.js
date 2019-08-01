App = {
  web3Provider: null,
  contracts: {},

  init: async function() {
      return await App.initWeb3();
  },

  initWeb3: async function() {
      // Modern dapp browsers...
  if (window.ethereum) {
    App.web3Provider = window.ethereum;
    try {
      // Request account access
      await window.ethereum.enable();
    } catch (error) {
    // User denied account access...
    console.error("User denied account access")
   }
  }
// Legacy dapp browsers...
else if (window.web3) {
  App.web3Provider = window.web3.currentProvider;
}
// If no injected web3 instance is detected, fall back to Ganache
else {
  App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
}
web3 = new Web3(App.web3Provider);


web3.eth.getAccounts(function(error, accounts) {
  if (error) {
    console.log(error);
  }

  var account = accounts[0];
  $('#user-address').text(account);
});

return App.initContract();
},

  initContract: function() {
    $.getJSON('./Main.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var MainArtifact = data;
      App.contracts.Main = TruffleContract(MainArtifact);
    
      // Set the provider for our contract
      App.contracts.Main.setProvider(App.web3Provider);
    
      // Use our contract to retrieve and mark the adopted pets
    });
    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '#proposal', App.createContract);
    $(document).on('click', '#incentiveProposal', App.createIncentivizeContract);
  },

  listProposals: function(Proposals, account) {
    var proposalsInstance;

    App.contracts.Main.deployed().then(function(instance) {
      proposalsInstance = instance;
    
      return proposalsInstance.getProposals.call();
    }).then(function(Proposals) {
      for (i = 0; i < Proposals.length; i++) {
        if (Proposals[i] !== '0x0000000000000000000000000000000000000000') {
          $('.panel-pet').eq(i).find('button').text('Success').attr('disabled', true);
        }
      }
    }).catch(function(err) {
      console.log(err.message);
    });
    
  },

createContract: async function(event){
  event.preventDefault();

  var topic = $('#topic1').val();
  var desc = $('#description1').val();
  var ReviewPhaseLengthInSeconds = parseInt($('#ReviewTime1').val());
  var CommitPhaseLengthInSeconds = parseInt($('#CommitTime1').val());
  var RevealPhaseLengthInSeconds = parseInt($('#ReviewTime1').val());
  
  if(topic == ''){
    alert('Topic is Empty');
    return null;
  }
  if(desc == ''){
    alert('Description is Empty');
    return null;
  }
  if(docs == ''){
    alert('Docs is Empty');
    return null;
  }
  if(ReviewPhaseLengthInSeconds == null){
    alert('Review Time Period is Empty');
    return null;
  }
  if(CommitPhaseLengthInSeconds == null){
    alert('Commit Time Period is Empty');
    return null;
  }  
  if(RevealPhaseLengthInSeconds == null){
    alert('Reveal Time Period is Empty');
    return null;
  }

  var docs = document.getElementById('file1');
  const file = docs.files[0]
  
  const ipfs = window.IpfsHttpClient('ipfs.infura.io', '5001', {protocol:'https'});
  await ipfs.add(file, (err, result) => {
    if(err) {
      console.error(err);
      return
    }
    var url = `https://ipfs.io/ipfs/${result[0].hash}`
    console.log(`Url --> ${url}`);
  var mainInstance;
    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.Main.deployed().then(function(instance) {
        mainInstance = instance;

    // Execute adopt as a transaction by sending account
    return mainInstance.Proposal(topic,desc,url,ReviewPhaseLengthInSeconds, CommitPhaseLengthInSeconds, RevealPhaseLengthInSeconds, {from: account});
  }).then(function(result) {
    alert('Your Proposal has been Created');
    //return App.listProposals;
  }).catch(function(err) {
    console.log(err.message);
  });
});
});

},

createIncentivizeContract: async function(event){
  event.preventDefault();

  var topic = $('#topic').val();
  var desc = $('#description').val();
  var ReviewPhaseLengthInSeconds = parseInt($('#ReviewTime').val());
  var CommitPhaseLengthInSeconds = parseInt($('#CommitTime').val());
  var RevealPhaseLengthInSeconds = parseInt($('#ReviewTime').val());
  var SecurityEntryDeposit = parseInt($('#SecurityEntryDeposit').val());
  var Reward = parseInt($('#Reward').val());

  console.log(SecurityEntryDeposit);

  if(topic == ''){
    alert('Topic is Empty');
    return null;
  }
  if(desc == ''){
    alert('Description is Empty');
    return null;
  }
  if(docs == ''){
    alert('Docs is Empty');
    return null;
  }
  if(ReviewPhaseLengthInSeconds == null){
    alert('Review Time Period is Empty');
    return null;
  }
  if(CommitPhaseLengthInSeconds == null){
    alert('Commit Time Period is Empty');
    return null;
  }  
  if(RevealPhaseLengthInSeconds == null){
    alert('Reveal Time Period is Empty');
    return null;
  }
  if(SecurityEntryDeposit == null){
    alert('Security Entry Deposit is Empty');
    return null;
  }

  var docs = document.getElementById('file');
  const file = docs.files[0]
  
  const ipfs = window.IpfsHttpClient('ipfs.infura.io', '5001', {protocol:'https'});
  await ipfs.add(file, (err, result) => {
    if(err) {
      console.error(err);
      return
    }
    var url = `https://ipfs.io/ipfs/${result[0].hash}`
    console.log(`Url --> ${url}`);
  var mainInstance;
    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.Main.deployed().then(function(instance) {
        mainInstance = instance;

    // Execute adopt as a transaction by sending account
    return mainInstance.incentivizeProposal(topic,desc,url,ReviewPhaseLengthInSeconds, CommitPhaseLengthInSeconds, RevealPhaseLengthInSeconds ,SecurityEntryDeposit,Reward, {from: account});
  }).then(function(result) {
    alert('Your Incentivized Proposal has been Created');
    //return App.listProposals;
  }).catch(function(err) {
    console.log(err.message);
  });
});
});

},


//   handleAdopt: function(event) {
//     event.preventDefault();

//     var petId = parseInt($(event.target).data('id'));
//     var adoptionInstance;

//     web3.eth.getAccounts(function(error, accounts) {
//       if (error) {
//         console.log(error);
//       }
    
//       var account = accounts[0];
    
//       App.contracts.Adoption.deployed().then(function(instance) {
//         adoptionInstance = instance;
    
//         // Execute adopt as a transaction by sending account
//         return adoptionInstance.adopt(petId, {from: account});
//       }).then(function(result) {
//         return App.markAdopted();
//       }).catch(function(err) {
//         console.log(err.message);
//       });
//     });
    
//   }

 };

$(function() {
  $(window).load(function() {
    App.init();
  });
});