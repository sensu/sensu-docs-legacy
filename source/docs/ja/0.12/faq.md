---
version: "0.12"
category: "Project"
title: "FAQ (日本語訳)"
---

# FAQ

### What's the latest version of Sensu?（sensu の latest バージョンは？）

The latest version of Sensu is 0.12.

sensu の latest バージョンは 0.12 です。

### Does Sensu run on Windows?（Windows でも動く？）

Yes. There is an MSI package for installing Sensu on Windows. You can
learn more about it [here](packages).

動きます。Windows での sensu インストールは MSI パッケージが提供されている。詳細は[こちら](packages) を御覧ください。

### How do Sensu clients handle network issues or RabbitMQ outages?（sensu クライアントは RabbitMQ の停止やネットワークの問題をハンドリング出来るの？）

The Sensu client is able to handle network issues and RabbitMQ outages
by attempting to reconnect to RabbitMQ on connection failure. The
Sensu client immediately attempts to reconnect. If unsuccessful, it
will make further attempts every 10 seconds, indefinitely.

sensu クライアントは RabbitMQ の停止やネットワークの問題をハンドリング出来ます。RabbitMQ への再接続を試みることによって行います。ネットワーク障害や RabbitMQ への接続に問題がある場合に sensu クライアントはすぐに再接続します。もし失敗しても 無期限に 10 秒毎にリトライします。

### Do I need to synchronize my clocks?（時刻の同期は必要？）

Yes. As Sensu components use their local clocks for timestamps, they
must be synchronized. Not synchronizing your clocks may result in
client keepalive event false positives. Time synchronization can be
done with NTP. See
[here](https://help.ubuntu.com/12.04/serverguide/NTP.html) for more
details.

必要です。
sensu の各コンポーネントはタイムスタンプの為にローカルホストの時刻を利用するのでそれらは同期しなければいけない。同期されない場合にクライアントの keepalive イベントに失敗する可能性があります。時刻の同期は NTP で行うことが出来ます。詳しくは [こちら](https://help.ubuntu.com/12.04/serverguide/NTP.html) を見て下さい。

### How do I delete a client?（クライアントを削除するにはどうするの？）

When you retire a system from your infrastructure, that was running a
Sensu client, a keepalive event will be created for it until it has
been removed from the registry.


インフラからシステムを退役させる際、 登録を削除するまで sensu クライアントは keepalive イベントを作成し続けます。

There are two methods for deleting clients: via the Sensu API or
through the Sensu Dashboard.

クライアントを削除する方法は Sensu API か Sensu Dashboard から削除する方法の 2 つの方法があります。

#### Using the API（API で削除する場合）

``` bash
curl -X DELETE http://<sensu-api>/client/<node>
```

#### Using the Sensu Dashboard（Sensu ダッシュボードを使う場合）

Click **Clients** > (click on a client) > **Remove**

`Clients` をクリックして `Remove` をクリックします。

Additionally, you can use the
[sensu-cli](https://rubygems.org/gems/sensu-cli) to delete clients.

また、[sensu-cli](https://rubygems.org/gems/sensu-cli) を使ってクライアントを削除することも出来ます。

``` bash
sensu-client delete NODE
```

### How do I increase log verbosity?（ログを詳細に見たいんだけど...）

You can toggle debug logging on and off by sending the Sensu process a
`USR1` signal.

Sensu Server のプロセスに `USR1` のシグナルを送ることでデバッグログのオンとオフを切り替えることが出来ます。

For example:

以下は例

``` bash
$ ps aux | grep [s]ensu-server
sensu     5992  1.7  0.3 177232 24352 ...
$ kill -USR1 5992
```

You can adjust the process log level by setting `LOG_LEVEL` in
`/etc/default/sensu` to either `debug`, `info`, `warn` or `error`. You
will need to restart the Sensu process(s) after making the adjustment.

`/etc/default/sensu` 内の `LOG_LEVEL` で `debug` や `warn` 又は `error` を設定することでログの出力を調整することが出来ます。設定したら Sensu のプロセスを再起動する必要があるので注意が必要です。

### Any suggestions on naming conventions for metric plugins?（メトリクスプラグインの命名規則について提案はあるの？）

The `*service_name*-metrics` seems to be the convention.

`サービス名-metrics` を付けておくのが無難（一般的、慣例）なようです。

### Does Sensu require that Redis and RabbitMQ run locally?（Sensu は Redis や RabbitMQ をローカルで動かすことを求めてるの？）

No. Redis and RabbitMQ can run locally or on any remote host, so long
as the Sensu components can communicate with them.

うんにゃ。Redis と RabbitMQ はローカルでも Sensu のコンポーネントと通信することが出来ればリモートホストでも実行することが出来ます。

### Which components of a Sensu system need access to Redis?（どの Sensu コンポーネントが Redis と通信するの？）

Only the Sensu server(s) and API communicate with Redis.

Sensu server と Sensu API が Redis と通信します。

### Which components of a Sensu system need access to the RabbitMQ broker?（どの Sensu コンポーネントが RabbitMQ broker にアクセスするの？）

The core Sensu components (server, client, and API) require access to
the RabbitMQ broker.

コアな Sensu コンポーネント（server と client そして API）は RabbitMQ broker との接続を必要としています。

### Can I run multiple Sensu servers?（複数の Sensu server を実行出来るの？）

Yes. You can run as many Sensu servers as you require. Check results
are distributed to Sensu servers in a round-robin fashion, allowing
you to scale out. Running more that one Sensu server is recommended.

出来ます。要求する限りの Sensu server を実行することが出来ます。チェック結果はラウンドロビンされているスケールアウトされた Sensu server に配布されます。一台の Sensu server でより多くの仕事をさせることを推奨しています。

### When I have multiple Sensu servers, which one will be the master?（複数の Sensu server がある場合にどちらが master になるの？）

The Sensu server master is responsible for check request publishing.
Master election is automatic, and so is failover. No configuration is
required.

Sensu server マスターは check request の発行を担当しています。Master は自動的に選択されフェイルオーバーも行われるので設定の必要はありません。

### How do I register a Sensu client?（Sensu クライアントはどうやって登録するの？）

Sensu clients self-register when they start up. You do not have to
maintain a list of your clients. The Sensu clients must be configured
correctly in order to run.

Sensu クライアントは sensu-client が起動する時に自動的に登録されるから君がクライアントのリストをメンテナンスする必要ありません。sensu-client が実行されるために正しく設定する必要がありません。

### Is there a configuration parameter to notify only every hour, even if the check has an interval of one minute?（一定の時間で通知する設定パラメータにチェックは一分間間隔が設定されているのはなぜですか？）

If your event handler uses the `sensu-plugin` library,
`Sensu::Handler`, you can add `refresh` to your check definitions,
with a numeric value representing time in seconds.

イベントハンドラに `sensu-plugin` ライブラリの `Sensu::Handler` を使っているならチェックの定義に `refresh` を秒単位の数値で追加することができます。

### What is client safe mode?（クライアントのセーフモードって何？）

In safe mode a client will not run a check published by a server
unless that check is also defined on the client.

セーフモードではそのチェックがクライアント上で定義されていない限りサーバが発行するチェックを実行しません。

### Do checks need to exist on the client?（チェックはクライアント上に存在する必要がありますか？）

No. They only need to be defined on the Sensu server(s), but can be
defined on the client to override certain check definition attributes.
Another case where a check needs to be present on the client is when
it is being defined as a standalone check. In `safe mode` the check
has to exist on both the client and the server.

いいえ。それらは Sensu Server(s) のみに定義される必要があります。しかし、特定のチェック定義（属性）をオーバーライドするには、クライアントに定義することが出来ます。別のケースとして、スタンドアロンチェックとして定義されている場合にチェックがクライアント上に存在する必要があります。また、 `セーフモード`でのチェックは、クライアントとサーバーの両方に存在している必要があります。

### How do I configure a standalone-check?（どうやって standalone-check をしますか？）

Standalone-checks are configured in this example:
http://blog.pkhamre.com/2012/03/21/sensu-standalone-checks/

Standalone-check は以下の例で設定してみて下さい。
http://blog.pkhamre.com/2012/03/21/sensu-standalone-checks/

### How can I use the Sensu embedded Ruby for checks and handlers?（どうやって Sensu 組み込みの Ruby を Check や handler から利用出来るの？）

You can use the embedded Ruby by setting `EMBEDDED_RUBY=true` in
`/etc/default/sensu`. The Sensu init scripts will set PATH and
GEM_PATH appropriately.

`/etc/default/sensu` で `EMBEDDED_RUBY=true` とすれば組み込みの Ruby を利用することが出来る。Sensu は init scripts で PATH や GEM_PATH を適切に設定してくれるでしょう。

Note: Using the embedded Ruby fixes conflicts with RVM.

### My machine can't find Ruby. What should I do?（私のマシンで Ruby が無いっぽいけど...何をすべき？）

* Check that your `PATH` is set correctly. If you're using embedded
 Ruby, it should indicate an Sensu embedded binary path, for example
 `/opt/sensu/embedded/bin/`.
 
* `PATH` が正しく設定されているかを確認しよう。もし、Sensu の組み込み Ruby を利用している場合 Sensu 組み込み Ruby の PATH を設定するべきです。（例：`/opt/sensu/embedded/bin/`）
 
* Try running a check whose content is only this command:
 `/usr/bin/env ruby -v` and inspect the output.
 
* 以下のコマンドを実行して確認して下さい:
 `/usr/bin/env ruby -v` の出力結果を確認しよう
 
* Check your script's line-endings. On Linux/Unix machines you should
 ensure your line endings are correct using a command like `dos2unix`.
 This will ensure Microsoft Windows line endings, for example
 extraneous `^M` endings, are removed.

* あなたのスクリプトの最後の行を確認してみて下さい。Linux や Unix マシンで `dos2unix` のようなコマンドを利用して行末を確認する必要があります。（例えば語尾の余分な`^M'が削除され、これは、Microsoft Windows で作成されたファイルの行末を保証します。）

### What is an API stash?（API stash とはなにか？）

[Stashes](api-stashes) allow you to store and retrieve JSON with the
[API](api). Sensu checks, handlers, etc. can utilize stashes as
needed. For instance, this would allow you to store Campfire
credentials in a stash on the API and then have a handler fetch the
stash. They are roughly analogous to data bags in Chef.

Stashes は API を使って JSON を保存したり復旧したりすることが出来ます。Sensu checks やハンドラ等は必要な stash を利用出来ます。例えば、API stash で Campfire
credentials を保存出来たり、handler fetch the stash を持てたりする。Chef の data bags に類似しています。

### What does silencing an event using the Sensu dashboard do?（Sensu dashboard を利用したイベントのサイレンシングは何が実施しているのでしょうか？）

The Sensu dashboard creates API stashes to silence events using a
combination of client name and/or the check name. Handlers that
utilize the `sensu-plugin` library or similar functionality query the
Sensu API for silence stashes, and act accordingly.

Sensu のダッシュボードには、client name と cleint name と check name 組み合わせを使用してイベントをサイレンシングする API stash を作成します。`Sensu-Plugin` ライブラリ又は同様の機能を利用するハンドラがサイレンススタッシュ用の Sensu API によってアクションを起こします。

### Why do you recommend a single SSL certificate for all Sensu Clients?（なぜ全てのクライアントで一つの SSL 証明書が必要なの？）

Learn more about Sensu and SSL certificates [here](certificates).

Sensu と SSL 証明書については[こちら](certificates)を見てね。

### What do I do if one of my machines is compromised and the Sensu client certificate is stolen?（機器の故障や証明書が紛失した場合にはどうすればいいですか？）

Re-create your CA and client certificates, re-distribute to your
RabbitMQ server, Sensu server, and Sensu clients.

再作成した CA 証明書とクライアント証明書を、あなたの RabbitMQ のサーバー、sensu server 、sensu client に再配布しましょう。

Learn more about Sensu and SSL certificates [here](certificates).

Sensu と SSL 証明書について詳しい情報は [here](certificates) を確認しましょう。

### What is the Sensu equivalent of Zenoss' Thresholds and Escalate Count（Zenoss のしきい値とエスカレートカウントは Sensu と何が同等ですか？）

If your event handler uses the `sensu-plugin` library,
`Sensu::Handler`, you can add `occurrences` to your check definitions,
instructing handlers to wait for a number of occurrences before taking
action.

もし、あなたがイベントハンドラとして `sensu-plugin` ライブラリの `Sensu::Handler` を使っているならば、様々な現象を待つように指示するチェックの定義に `occurrences` を追加することが出来ます。
