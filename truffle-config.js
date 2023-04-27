module.exports = {
  networks: {
    development: {
      //host: "192.168.1.45",
      host: '127.0.0.1',
      port: 7545,
      network_id: '*',
    },
  },
  contracts_directory: './contracts',
  compilers: {
    solc: {
      version: '0.8.19',
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },

  db: {
    enabled: false,
  },
};
