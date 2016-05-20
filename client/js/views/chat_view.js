/**
 * @fileOverview This file has functions related to chat view. This view calling from footer view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: undefined.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Chat View
 * @class ChatView
 * @constructor
 * @extends Backbone.View
 */
App.ChatView = Backbone.View.extend({
    template: JST['templates/chat'],
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        this.render();
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template()).attr('title', i18next.t('Chat'));
        this.$el.dockmodal({
            initialState: 'docked',
            height: 300,
            width: 400,
            animationSpeed: ANIMATION_SPEED
        });
        this.showTooltip();
        return this;
    }
});
