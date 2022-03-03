package com.example.wallet_connect_flutter

import android.content.Context
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.lifecycle.ViewModelProvider
import com.walletconnect.walletconnectv2.client.WalletConnect
import com.walletconnect.walletconnectv2.client.WalletConnectClient
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject


const val CHANNEL = "connectionChannel"
const val APPROVE_CHANNEL = "approveChannel"
const val CHANNEL_LIST = "channellist"
const val INITIAL_CHANNEL_LIST = "initialchannellist"
const val REJECT_CHANNEL = "rejectChannel"
const val DISCONNECT_TOPIC_CHANNEL = "disconnectTopicChannel"
const val METHODS_CLICK_CHANNEL = "methodClickChannel"
//class MainActivity: FlutterActivity() {
class MainActivity: FlutterFragmentActivity() , SessionActionListener{
    val TAG = MainActivity::class.java.simpleName
    private lateinit var viewModel: MainViewModel
    private lateinit var mContext:Context
    private val sessionAdapter = SessionsAdapter(this)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // view model instance
    }
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        viewModel= ViewModelProvider(this).get(MainViewModel::class.java)
        mContext = this@MainActivity
            connectChannel()
            approveRequestChannel()
            channelList()
            initialchannelList()
            rejectChannel()
            disconnectTopicChannel()
            approveDialog()
        methodClickChannel()
    }




    var methodChannelNameStr=""
    lateinit var golbalresult: MethodChannel.Result
    lateinit var disconnectresult: MethodChannel.Result
    fun connectChannel(){
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { // Note: this method is invoked on the main thread.
                call, result ->
            if(call.method=="initConnection"){
                methodChannelNameStr="initConnection"
                viewModel.pair(call.argument<String>("uri")!!)
                golbalresult = result
//                approveDialog()
            }
        }
    }

    /*
    * reject the join session request
    * */
    fun rejectChannel(){
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, REJECT_CHANNEL).setMethodCallHandler { // Note: this method is invoked on the main thread.
                call, result ->
            if(call.method=="reject"){
                methodChannelNameStr="reject"
                golbalresult = result
            }
        }
    }

    /*
    * disconnect from any channel topic
    * */
    fun disconnectTopicChannel(){
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, DISCONNECT_TOPIC_CHANNEL).setMethodCallHandler { // Note: this method is invoked on the main thread.
                call, result ->
            Log.e(TAG,"disconnectTopicChannel.method>> "+call.method)
            if(call.method=="disconnectTopic"){
                methodChannelNameStr="disconnectTopic"
                disconnectresult = result
                val topic = call.argument<String>("topic")!!
                viewModel.disconnect(topic)
               disconnectresult.success(topic)

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
            if(call.method=="approve") {
                methodChannelNameStr = "approve"
                golbalresult = result
                viewModel.approve(call.argument<String>("accountId")!!)
            }
        }
    }


    fun initialchannelList()
    {
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, INITIAL_CHANNEL_LIST).setMethodCallHandler { // Note: this method is invoked on the main thread.
                call, result ->

            if(call.method=="initialchannellistData") {
                methodChannelNameStr = "initialchannellistData"
                Log.e(TAG,"initialchannellistDatacall.methoddd: ${call.method} ${WalletConnectClient.getListOfSettledSessions().size}")

                if(viewModel.initialList().size>0){
                    val jsonArray = JSONArray()

//                    result.success(jsonArray.toString())
                        result.success( manageList(viewModel.initialList()).toString())
                }else{
                    result.success( manageList(ArrayList()).toString())
                }
            }
        }
    }


    fun methodClickChannel()
    {
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, METHODS_CLICK_CHANNEL).setMethodCallHandler { // Note: this method is invoked on the main thread.
                call, result ->

            if(call.method=="methodClickChannel") {
                methodChannelNameStr = "methodClickChannel"

                golbalresult = result

            }
        }
    }

    fun channelList()
    {
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL_LIST).setMethodCallHandler { // Note: this method is invoked on the main thread.
                call, result ->

            if(call.method=="channellistData") {
                methodChannelNameStr = "channellistData"
                if(sessionAdapter.getUpdateList().size>0){
                    result.success( manageList(sessionAdapter.getUpdateList()).toString())
                }

            }
        }
    }


    /*
    * send back to flutter for approve dialog show in flutter
    * */
    fun approveDialog(){

        viewModel.eventFlow.observe(this) { event ->
            Log.e(TAG,"initialeventttt $event")

            when (event ) {
                is InitSessionsList -> {
                    sessionAdapter.updateList(event.sessions)

                }
                is ShowSessionProposalDialog -> {
                    if(methodChannelNameStr == "initConnection") {
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
                        golbalresult.success(postData.toString())
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

                   Log.e(TAG, "methodChannelNameStr> "+  (methodChannelNameStr))
                   Log.e(TAG, "EEEEErespondRequest> "+  (event.sessionRequest))
                   Log.e(TAG, "EEEEErespondRequest> "+  viewModel.respondRequest(event.sessionRequest))

                    if(methodChannelNameStr=="methodClickChannel") {
                        val sessionRequest = event.sessionRequest
                        val postData = JSONObject()
                        postData.put("chainId", sessionRequest.chainId)
                        val jsonRpcReq =  sessionRequest.request
                        var jsonRpc = JSONObject()
                        jsonRpc.put("id",jsonRpcReq.id)
                        jsonRpc.put("method",jsonRpcReq.method)
                        jsonRpc.put("params",jsonRpcReq.params)

                        postData.put("jsonrequest", jsonRpc)
                        postData.put("topic", sessionRequest.topic)
                        Log.e(TAG,"postData.toString() >> ${postData.toString()}")
                        golbalresult.success(postData.toString())

                    }

                }
                is UpdateActiveSessions -> {


                    if(methodChannelNameStr == "approve") {
                        sessionAdapter.updateList(event.sessions)

                        val list = ArrayList<WalletConnect.Model.SettledSession>()
                        list.add(sessionAdapter.getUpdateList().get(0))
                        golbalresult.success(list.toString())
                        channelList()
                        /*proposalDialog?.dismiss()
                    */
                       /* event.message?.let {
                            Toast.makeText(this, it, Toast.LENGTH_SHORT).show()
                        }*/
                    }else{


                    }
                }
                is RejectSession -> {
//                    proposalDialog?.dismiss()
                    //rejectChannel
                    if(methodChannelNameStr == "reject") {
                        golbalresult.success(true)
                    }
                }
                is PingSuccess -> Toast.makeText(this , "Successful session ping", Toast.LENGTH_SHORT).show()
            }
        }
    }

    override fun onDisconnect(session: WalletConnect.Model.SettledSession) {
        viewModel.disconnect(session.topic)
        if(methodChannelNameStr == "disconnectTopic") {
            golbalresult.success(session.topic)
        }

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

    fun manageList(list : List<WalletConnect.Model.SettledSession>):JSONArray{
        val jsonArray = JSONArray()
//        for(i in sessionAdapter.getUpdateList()) {
        for(i in list) {
            val postData = JSONObject()
            Log.e(TAG,"i.topic: ${i.topic}")
            postData.put("topic",i.topic)
            postData.put("accounts",i.accounts)
            postData.put("accounts",i.accounts)
            postData.put("peermeta_description",i.peerAppMetaData?.description)
            postData.put("peermeta_name",i.peerAppMetaData?.name)
            postData.put("peermeta_url",i.peerAppMetaData?.url)
            postData.put("peermeta_icons",i.peerAppMetaData?.icons)


            postData.put("permissons_blockchain" , i.permissions.blockchain.chains)
            postData.put("permissons_jsonRpc" , i.permissions.jsonRpc.methods)
            postData.put("permissons_notifications" , i.permissions.notifications.types)
            jsonArray.put(postData)
        }
        return jsonArray
    }

}
