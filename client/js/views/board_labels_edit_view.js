App.BoardLabelsEditView = Backbone.View.extend({
    /**
     * Constructor
     * initialize default values and actions
     */
    initialize: function(options) {
        if (!_.isUndefined(this.model) && this.model !== null) {
            this.model.showImage = this.showImage;
            if (!_.isUndefined(authuser.user) && !_.isUndefined(this.model.board_users)) {
                var board_user_role_id = this.model.board_users.findWhere({
                    user_id: parseInt(authuser.user.id)
                });
                if (!_.isEmpty(board_user_role_id)) {
                    this.model.board_user_role_id = board_user_role_id.attributes.board_user_role_id;
                }
            }
        }
        this.label = options.label;
        this.render();
    },
    template: JST['templates/board_labels_edit'],
    tagName: 'li',
    converter: new showdown.Converter({
        extensions: ['targetblank', 'xssfilter', 'codehighlight']
    }),
    /** 
     * Events
     * functions to fire on events (Mouse events, Keyboard Events, Frame/Object Events, Form Events, Drag Events, etc...)
     */
    events: {
        'click .js-delete-labels': 'deleteLabels',
        'submit form.js-edit-card-label': 'editLabels',
        'click .js-show-edit-card-label-form': 'showCardLabelEditForm',
        'click .js-card-label-color-pick': 'colorPicker',
        'click .js-change-label-color': 'changeLabelColor',
        'click .js-show-card-label-colorpicker': 'showCardLabelColorpicker'
    },
    /**
     * changeLabelColor()
     * change the label color
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    changeLabelColor: function(e) {
        var self = this;
        var data = {};
        data.color = $(e.currentTarget).data('color');
        $(e.target).closest('form').find('#color').val(data.color);
        $(e.currentTarget).parent('ul').find('span').html('');
        $(e.currentTarget).find('span').append('<i class="icon-ok icon-light"></i>');
        return false;
    },
    /**
     * editLabels()
     * edit the label name and color
     * @param e
     * @type Object(DOM event)
     * @return false
     *
     */
    editLabels: function(e) {
        var self = this;
        var data = {};
        data.label_id = $(e.target).closest('form').find('#label_id').val();
        data.name = $(e.target).closest('form').find('#inputCardLabel').val();
        data.color = $(e.target).closest('form').find('#color').val();
        var card_label = new App.Label();
        card_label.set('board_id', self.model.id);
        card_label.set('id', data.label_id);
        if (!_.isEmpty(data.color)) {
            card_label.set('color', data.color);
        }
        card_label.set('name', data.name);
        self.model.labels.each(function(label) {
            if (parseInt(label.attributes.label_id) === parseInt(data.label_id)) {
                label.set({
                    name: data.name
                });
                if (!_.isEmpty(data.color)) {
                    label.set({
                        color: data.color
                    });
                }
            }
        });
        card_label.url = api_url + 'labels/' + data.label_id + '.json';
        card_label.save(data, {
            patch: true,
            catch: false,
            success: function(model, response) {}
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
        this.converter.setFlavor('github');
        this.$el.html(this.template({
            board: this.model,
            label: this.label,
            converter: this.converter
        }));
        this.showTooltip();
        return this;
    }
});
