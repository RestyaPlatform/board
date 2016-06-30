/**
 * @fileOverview This file has functions related to board index header view. This view calling from apllication view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: user model
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * Header View
 * @class HeaderView
 * @constructor
 * @extends Backbone.View
 */
App.BoardIndexHeaderView = Backbone.View.extend({
    template: JST['templates/board_index_header'],
    className: 'navbar navbar-default',
    id: 'js-navbar-default',
    attributes: {
        role: 'navigation'
    },
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-close-popover': 'closePopup',
    },
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
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            page_title: this.model,
        }));
        this.showTooltip();
        return this;
    },

    /**
     * closePopup()
     * close opened dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    closePopup: function(e) {
        var target = $(e.target);
        target.parents('li.dropdown').removeClass('open');
        return false;
    }
});
