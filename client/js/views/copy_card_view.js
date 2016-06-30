/**
 * @fileOverview This file has functions related to copy card view. This view calling from modal card view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: card model. @see Available Object in App.CardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * CopyCard View
 * @class CopyCardView
 * @constructor
 * @extends Backbone.View
 */
App.CopyCardView = Backbone.View.extend({
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
    template: JST['templates/copy_card'],
    tagName: 'div',
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
            boards: this.boards
        }));
        this.showTooltip();
        return this;
    }
});
