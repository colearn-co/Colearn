function chatController(postId) {
    
    if (localStorage.getItem("desktopNotification") === null) {
        try {
            Notification.requestPermission().then(function (permission) { // denied, granted
                localStorage.setItem("desktopNotification", permission); //TPDO: move to sperate file(LocalStorageDAO)
            });
        } catch (error) {
            // Safari doesn't return a promise for requestPermissions and it
            // throws a TypeError. It takes a callback as the first argument
            // instead.
            if (error instanceof TypeError) {
                try {
                    Notification.requestPermission(function (permission) {
                        localStorage.setItem("desktopNotification", permission);
                    });
                } catch (e) {
                    util.emailErrors("Error while requesting notification(Without promise API): " + e.toString());
                    // ignore
                }

            } else {
                // TODO: ignore errors for now test safari
                // throw error;
                util.emailErrors("Error while requesting notification(Promise API): " + error.toString());
            }
        }

    }
    var chatDAO = new ChatDAO(postId);
    var lastChatId;
    var firstChatId;
    var isScrollingUp;
    var isWindowActive = true;
    var deviceId = "web:" + util.generateRandomString(16)

    $(window).blur(function () {
        isWindowActive = false;
    });
    $(window).focus(function () {
        isWindowActive = true;
    });
    chatDAO.getChatsInfo({limit: 30}, function (chatsInfo) {
        var members = [];
        var membersMap = {};
        chatsInfo.members.forEach(function (m) {
            var user = new User(m);
            members.push(user);
            membersMap[user.id] = user;
        });

        var chat = new Chat(new User(current_user), members, {}, function (message, callback) {
            chatDAO.sendMessage({message: message, src_device_id: deviceId}, function (error, data) {
                if (callback) {
                    callback(error, data);
                }
            });
        });

        if (chatsInfo.chats.length > 0) {
            lastChatId = chatsInfo.chats[chatsInfo.chats.length - 1].id;
            firstChatId = chatsInfo.chats[0].id; // handle case when no messages.
        }

        chat.setScrollTopEventCallback(function () {
            if (!isScrollingUp) {
                isScrollingUp = true;
                chatDAO.getChatsInfo({before_id: firstChatId, limit: 10}, function (ci) {
                    if (ci.chats.length > 0) {
                        firstChatId = ci.chats[0].id; // move this to a function
                    }
                    var messages = getMessagesFromChatInfo(ci);
                    chat.addMessagesToTop(messages);
                    isScrollingUp = false;
                });
            }
        });
        chat.addMessages(getMessagesFromChatInfo(chatsInfo));
        $('.js_upload_form').on("ajax:remotipartComplete", function (e, data) {
            var c = JSON.parse(data.responseText).chat;
            var msg = new Message(c, membersMap[c.user.id]);
            chat.addMessage(msg);
        });

        setInterval(function () {
            fetchLattestMessages(lastChatId);
        }, 5000);

        function getMessagesFromChatInfo(chatsInfo, excludeMyMessages) {
            var messages = [];
            chatsInfo.chats.forEach(function (chat) {
                if (!(excludeMyMessages && chat.user.id === current_user.id 
                    && chat.src_device_id === deviceId)) {
                    var message = new Message(chat, membersMap[chat.user.id]);
                    messages.push(message);
                } // TODO this will not work if multiple windows are open FIX
            });
            return messages;
        }

        function getUsersFromChatInfo(chatsInfo) {
            var members = [];
            chatsInfo.members.forEach(function (m) {
                var user = new User(m);
                members.push(user);
            });
            return members;
        }

        function fetchLattestMessages() {
            chatDAO.getChatsInfo({after_id: lastChatId}, function (ci) {
                if (ci.chats.length > 0) {
                    lastChatId = ci.chats[ci.chats.length - 1].id; // move this to a function
                }
                var messages = getMessagesFromChatInfo(ci, true);
                chat.addMessages(messages);
                chat.addUsersToUserArea(getUsersFromChatInfo(ci));
                desktopNotification(messages);
            });
        }

    });

    function desktopNotification(messages) {
        if (!isWindowActive && localStorage.getItem("desktopNotification") === "granted") {
            messages.forEach(function (message) {
                var notification = new Notification('New message from ' + message.user.username, {
                    icon: message.user.picture,
                    body: message.text
                    //sound: path //TODO
                });

                notification.onclick = function () {
                    window.focus();
                    //window.open("http://stackoverflow.com/a/13328397/1269037");
                };
            });
        }
    }

}


