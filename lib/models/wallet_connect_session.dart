class WalletConnectSession {

  String name;
  String icon;
  String description;
  String chains;
  String methods;
  String topic;
  String url;
  String accounts;

  WalletConnectSession(
      this.name, this.icon, this.description, this.chains, this.methods, this.topic, this.url, this.accounts);

  factory WalletConnectSession.fromJson(Map<String,dynamic> json) => WalletConnectSession(
      json['peermeta_name'],
      json['peermeta_icons'].toString(),
      json['peermeta_description'],
      json['permissons_blockchain'].toString(),
      json['permissons_jsonRpc'].toString(),
      json['topic'],
      json['peermeta_url'],
      json['accounts'].toString(),
  );

  @override
  String toString() {
    return 'WalletConnectSession{name: $name, icon: $icon, description: $description, chains: $chains, methods: $methods, topic: $topic, url: $url, accounts: $accounts}';
  }

}