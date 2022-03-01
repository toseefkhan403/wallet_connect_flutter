package com.example.wallet_connect_flutter

import android.content.Context
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.lifecycle.ViewModelProvider
import com.walletconnect.walletconnectv2.client.WalletConnect
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject


const val CHANNEL = "connectionChannel"
const val APPROVE_CHANNEL = "approveChannel"
//class MainActivity: FlutterActivity() {
class MainActivity: FlutterFragmentActivity() , SessionActionListener{
    val TAG = MainActivity::class.java.simpleName
    private lateinit var viewModel: MainViewModel
    private lateinit var mContext:Context
    private val sessionAdapter = SessionsAdapter(this)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // view model instance
        viewModel= ViewModelProvider(this).get(MainViewModel::class.java)
        mContext = this@MainActivity
    }
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)


            connectChannel()
//            approveRequestChannel()

    }

    var methodChannelNameStr=""
    fun connectChannel(){
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { // Note: this method is invoked on the main thread.
                call, result ->
            if(call.method=="initConnection"){
                methodChannelNameStr="initConnection"
                viewModel.pair(call.argument<String>("uri")!!)
                approveDialog(result)
            }
        }
    }

    /*
    * send approve request to wallet and return to flutter
    * */
  fun approveRequestChannel()
    {
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, APPROVE_CHANNEL).setMethodCallHandler { // Note: this method is invoked on the main thread.
                call, result ->
            Log.d(TAG, "call.args: ${call.arguments}")

            if(call.method=="approve") {
                methodChannelNameStr = "approve"
                viewModel.approve(call.argument<String>("accountId")!!)
            }
        }
    }


    /*
    * send back to flutter for approve dialog show in flutter
    * */
    fun approveDialog(result: MethodChannel.Result){

        viewModel.eventFlow.observe(this) { event ->
            Log.e(TAG,"eventttt $event")

            when (event ) {
                is InitSessionsList -> {
//                    sessionAdapter.updateList(event.sessions)
                }
                is ShowSessionProposalDialog -> {
                    if(methodChannelNameStr == "initConnection") {
                        Log.e(TAG, "event.proposal>> " + event.proposal)/* proposalDialog = SessionProposalDialog(
                        requireContext(),
                        viewModel::approve,
                        viewModel::reject,
                        event.proposal
                    )
                    proposalDialog?.show()*/
                        val v: WalletConnect.Model.SessionProposal = event.proposal
                        val postData = JSONObject()
                        postData.put("name", v.name)
                        postData.put("accounts", v.accounts)
                        postData.put("chains", v.chains)
                        postData.put("description", v.description)
                        postData.put("icon", v.icon)
                        postData.put("icons", v.icons)
                        postData.put("isController", v.isController)
                        postData.put("methods", v.methods)
                        postData.put("proposerPublicKey", v.proposerPublicKey)
                        postData.put("relayProtocol", v.relayProtocol)
                        postData.put("topic", v.topic)
                        result.success(postData.toString())
                    }
                }
                is ShowSessionRequestDialog -> {
                    /*requestDialog = SessionRequestDialog(
                        requireContext(),
                        { sessionRequest -> viewModel.respondRequest(sessionRequest) },
                        { sessionRequest -> viewModel.rejectRequest(sessionRequest) },
                        event.sessionRequest,
                        event.session
                    )
                    requestDialog?.show()*/
                }
                is UpdateActiveSessions -> {
                    if(methodChannelNameStr == "approve") {
                        sessionAdapter.updateList(event.sessions)
                        Log.d(TAG, "event.sessions>>>> " + event.sessions)
                        Log.d(TAG, "event.sessions.size>>>> " + event.sessions.size)

                        val list = ArrayList<WalletConnect.Model.SettledSession>()
                        list.add(sessionAdapter.getUpdateList().get(0))
                        result.success(list.toString())
                        Log.d(TAG, "sendresultttt kotlin to flutter")
                        /*proposalDialog?.dismiss()
                    */
                       /* event.message?.let {
                            Toast.makeText(this, it, Toast.LENGTH_SHORT).show()
                        }*/
                    }
                }
                is RejectSession -> {
//                    proposalDialog?.dismiss()
                }
                is PingSuccess -> Toast.makeText(this , "Successful session ping", Toast.LENGTH_SHORT).show()
            }
        }
    }

    override fun onDisconnect(session: WalletConnect.Model.SettledSession) {
        viewModel.disconnect(session.topic)
    }

    override fun onUpdate(session: WalletConnect.Model.SettledSession) {
        viewModel.sessionUpdate(session)
    }

    override fun onUpgrade(session: WalletConnect.Model.SettledSession) {
        viewModel.sessionUpgrade(session)
    }

    override fun onPing(session: WalletConnect.Model.SettledSession) {
        viewModel.sessionPing(session)
    }

    override fun onSessionsDetails(session: WalletConnect.Model.SettledSession) {

//        SessionDetailsDialog(this, session).show()
    }

}
