/**
 * @fileOverview This file has functions related to board subscribe view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model. It contain all board based object @see Available Object in App.BoardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Subscribe Board Confirmation View
 * @class SubscribeBoardConfirmView
 * @constructor
 * @extends Backbone.View
 */
App.SubscribeBoardConfirmView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.render();
    },
    template: JST['templates/subscribe_board_confirm'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-subscribe-board': 'subcribeBoard',
    },
    subcribeBoard: function(e) {
        var self = this;
        var boardSubscriber = new App.BoardSubscriber();
        var data = {
            board_id: this.model.id,
            is_subscribed: 1
        };
        boardSubscriber.url = api_url + 'boards/' + this.model.id + '/board_subscribers.json';
        boardSubscriber.save(data, {
            success: function(model, response) {
                if (_.isUndefined(self.model.board_subscriber)) {
                    self.model.board_subscriber = boardSubscriber;
                } else {
                    self.model.board_subscriber.attributes.is_subscribed = 1;
                }
                $('.js-back-to-sidebar').trigger('click');
            }
        });
        return false;
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            board: this.model
        }));
        this.showTooltip();
        return this;
    }
});
