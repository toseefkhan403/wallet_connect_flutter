package com.example.wallet_connect_flutter

import android.app.Application
import com.walletconnect.walletconnectv2.client.WalletConnect
import com.walletconnect.walletconnectv2.client.WalletConnectClient


class AppApplication : Application(){

    override fun onCreate() {
        super.onCreate()

       /* val initDapp = WalletConnect.Params.Init(
            application = this,
            useTls = true,
            hostName = WALLET_CONNECT_URL,
            projectId = "7fef26ea40a4e8ecb22bc80aa6e4116d",     //TODO: register at https://walletconnect.com/register to get a project ID
            isController = false,
            metadata = WalletConnect.Model.AppMetaData(
                name = "Kotlin Dapp",
                description = "Dapp description",
                url = "example.dapp",
                icons = listOf("https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media")
            )
        )*/

        val initWallet = WalletConnect.Params.Init(
            application = this,
            relayServerUrl = "wss://relay.walletconnect.com?projectId=7fef26ea40a4e8ecb22bc80aa6e4116d",   //TODO: register at https://walletconnect.com/register to get a project ID
            isController = true,
            metadata = WalletConnect.Model.AppMetaData(
                name = "Phaeton Wallet",
                description = "Phaeton Wallet description",
                url = "https://phaeton.io",
                icons = listOf("https://phaeton.io/wp-content/uploads/2021/05/logo.png")
            )
        )

        WalletConnectClient.initialize(initWallet)
    }

    private companion object {
        const val WALLET_CONNECT_URL = "relay.walletconnect.com"
    }

}