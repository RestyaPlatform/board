/**
 * @fileOverview This file has functions related to copy from existing card view. This view calling from list view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: card model. @see Available Object in App.CardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * CopyFromExistingCard View
 * @class CopyFromExistingCardView
 * @constructor
 * @extends Backbone.View
 */
App.CopyFromExistingCardView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        this.boards = options.boards;
        this.render();
    },
    template: JST['templates/copy_from_existing_card'],
    tagName: 'ul',
    className: 'dropdown-menu dropdown-menu-right arrow arrow-right js-card-action-list-response js-dropdown-popup',
    /**
     * render()
     * populate the html to the dom
     * @param NULL
     * @return object
     *
     */
    render: function() {
        this.$el.html(this.template({
            card: this.model,
            boards: this.boards,
        }));
        this.showTooltip();
        return this;
    }
});
