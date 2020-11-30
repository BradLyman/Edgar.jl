exports.handler = async (event) => {
    console.log(JSON.stringify(event, null, "    "));

    /**
     * If Lex is trying to resolve an intent which should just be the user's
     * verbatim input, then just accept whatever they say.
     **/
    let last_operation =
        event.recentIntentSummaryView ? event.recentIntentSummaryView[0] : null;
    if (last_operation) {
        if (
            last_operation.dialogActionType == "ElicitSlot"
            && last_operation.slotToElicit == "TrialTitle"
        ) {
            event.currentIntent.slots.TrialTitle = event.inputTranscript;
        }
    }

    /**
     * Always delegate to lex to decide on what to do next in the conversation.
     * BUT, since the TrialTitle slot is resolved, Lex will not need to do any
     * more processing to figure out what it should be.
     **/
    let response = {
        "dialogAction": {
            "type": "Delegate",
            "slots": event.currentIntent.slots
        }
    };
    console.log("replying with " + JSON.stringify(response, null, "    "));

    return response;
};
