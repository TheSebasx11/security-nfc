module.exports = {
  networks: {
    development: {
<<<<<<< HEAD
      //host: "192.168.1.14",
      host: '127.0.0.1',
=======
      host: "192.168.1.36",
      //host: "127.0.0.1",
>>>>>>> b258c3bb1a6cc40b81825ee7202be5d5580601d5
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
