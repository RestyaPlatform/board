/**
 * @fileOverview This file has functions related to board unsubscribe view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model. It contain all board based object @see Available Object in App.BoardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Unsubscribe Board Confirmation View
 * @class UnsubscribeBoardConfirmView
 * @constructor
 * @extends Backbone.View
 */
App.UnsubscribeBoardConfirmView = Backbone.View.extend({
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
    template: JST['templates/unsubscribe_board_confirm'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-unsubscribe-board': 'unsubcribeBoard',
    },
    unsubcribeBoard: function(e) {
        if (!_.isUndefined(this.model.board_subscriber) && this.model.board_subscriber.attributes.id) {
            var self = this;
            var boardSubscriber = new App.BoardSubscriber();
            var data = {
                board_id: this.model.id,
                is_subscribed: 0
            };
            boardSubscriber.url = api_url + 'boards/' + this.model.id + '/board_subscribers/' + this.model.board_subscriber.attributes.id + '.json';
            boardSubscriber.set('id', this.model.board_subscriber.attributes.id);
            boardSubscriber.save(data, {
                success: function(model, response) {
                    self.model.board_subscriber.attributes.is_subscribed = 0;
                    $('.js-back-to-sidebar').trigger('click');
                }
            });
        }
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
