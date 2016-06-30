/**
 * @fileOverview This file has functions related to modal list view. This view calling from list view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: list model. @see Available Object in App.ListView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ModalList View
 * @class ModalListView
 * @constructor
 * @extends Backbone.View
 */
App.ModalChatHistoryView = Backbone.View.extend({
    id: 'base-modal',
    className: '',
    template: JST['templates/modal_chat_history_view'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'hidden': 'teardown',
        'click .js-close-popover': 'closePopup',
        'click #js-chat-histories-load-more': 'loadmorehistories'
    },
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.getListing();
        _(this).bindAll('show', 'teardown');
    },
    teardown: function() {
        this.$el.data('modal', null);
        this.remove();
    },
    /** 
     * getListing()
     * get settings
     * @return false
     */
    getListing: function() {
        var self = this;
        var view_user_chats = this.$('#js-chat-history-list');
        view_user_chats.html('');
        var chat_histories = new App.ChatHistoryCollection();
        var page = 1;
        chat_histories.url = api_url + 'boards/' + this.model.attributes.id + '/chat_history.json?page=' + page;
        chat_histories.fetch({
            success: function(chat_history, response) {
                if (chat_histories.length > 0) {
                    page = parseInt(page) + 1;
                    $('#js-chat-histories-load-more').attr('data-page', page);
                    self.renderChatHistoryCollection(chat_histories, response._metadata.total_records);
                } else {
                    $('#js-chat-histories-load-more').remove();
                    $('#js-chat-history-list').html('<div class="media-body">No Chat History available.</div>');
                }
            }
        });
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function(collections) {
        this.$el.html(this.template({
            chat_history: this.model
        }));
        this.$el.modal({
            show: true,
            backdrop: false
        });
        this.showTooltip();
        return this;
    },
    /**
     * show()
     * display list attachment
     */
    show: function() {
        this.render();
        this.$el.find('#modalChatHistoryView').modal('show');
    },
    /**
     * closePopup()
     * close opened dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     */
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        return false;
    },
    /**
     * loadmorehistories()
     * loadmorehistories
     * @return false
     */
    loadmorehistories: function() {
        var self = this;
        var chat_histories = new App.ChatHistoryCollection();
        var page = $('#js-chat-histories-load-more').attr('data-page');
        chat_histories.url = api_url + 'boards/' + this.model.attributes.id + '/chat_history.json&page=' + page;
        chat_histories.fetch({
            success: function(chat_history, response) {
                if (chat_histories.length > 0) {
                    page = parseInt(page) + 1;
                    $('#js-chat-histories-load-more').attr('data-page', page);
                    self.renderChatHistoryCollection(chat_histories, response._metadata.total_records);
                } else {
                    var view = new App.ChatHistoryView({
                        model: null
                    });
                    view_user_chats.append(view.render().el);
                }
            }
        });
    },
    /**
     * renderChatHistoryCollection()
     * render chats
     */
    renderChatHistoryCollection: function(chat_histories, total_records) {
        var view_user_chats = this.$('#js-chat-history-list');
        var page = $('#js-chat-histories-load-more').attr('data-page');
        if (chat_histories.length > 0) {
            if (chat_histories.length < PAGING_COUNT || total_records == (page - 1) * PAGING_COUNT) {
                $('#js-chat-histories-load-more').remove();
            }
            chat_histories.each(function(chat_history) {
                var view = new App.ChatHistoryView({
                    model: chat_history
                });
                view_user_chats.append(view.render().el).find('.timeago').timeago();
            });
        }
    }

});
