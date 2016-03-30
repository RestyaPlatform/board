/**
 * @fileOverview This file has functions related to archived lists view. This view calling from board header view.
 * Available Object:
 *	App.boards						: this object contain all boards(Based on logged in user)
 *	this.model						: board model and it's related values. It contain all list based object @see Available Object in App.BoardView
 */
if (typeof App === 'undefined') {
    App = {};
}
/**
 * ArchivedLists View
 * @class ArchivedListsView
 * @constructor
 * @extends Backbone.View
 */
App.ModalShortcutView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function() {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
        }
        //this.render();
    },
    template: JST['templates/modal_shortcut'],
    tagName: 'li',
    // className: 'clearfix col-xs-12',
    /**
     * show()
     * display list attachment in modal box
     *
     */
    show: function() {
        this.render();
        this.$el.find('#ModalShortcutView').modal('show');
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
            list: this.model
        }));
        this.$el.modal({
            show: true,
            backdrop: false
        });
        this.showTooltip();
        return this;
    }
});
