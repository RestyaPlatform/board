/**
 * @fileOverview This file has functions related to show board visibilit view. This view calling from board header view, board simple view and organization board view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model.
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ShowBoardVisibility View
 * @class ShowBoardVisibilityView
 * @constructor
 * @extends Backbone.View
 */
App.ShowBoardVisibilityView = Backbone.View.extend({
    tagName: 'ul',
    className: 'list-unstyled',
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
    template: JST['templates/show_board_visibility'],
    /**
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-close-popover': 'closePopup'
    },
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.el = this.template({
            visibility: this.model
        });
        this.delegateEvents(this.events);
        this.showTooltip();
        return this;
    },
    /**
     * boardRename()
     * close the dropdown
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    closePopup: function(e) {
        var el = this.$el;
        var target = el.find(e.target);
        target.parents('div.dropdown:first, li.dropdown:first').removeClass('open');
        return false;
    }
});
