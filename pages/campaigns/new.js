import React, { Component } from 'react';
import { Form, Button, Input, Message, Dropdown } from 'semantic-ui-react';
import Layout from '../../components/Layout';
import factory from '../../ethereum/factory';
import web3 from '../../ethereum/web3';
import { Router } from '../../routes';
const cities = require('../../cities.json');

const citiesMapped = cities.map((item, index) => { return {
  key: item.rank,
  text: item.city + " | " + item.state,
  value: item.city
}});

// console.log(cities[0], citiesMapped[0]);

class CampaignNew extends Component {
  state = {
    name: '',
    city: '',
    quantity: '',
    receiver: '',
    errorMessage: '',
    loading: false
  };

  onSubmit = async event => {
    event.preventDefault();

    this.setState({ loading: true, errorMessage: '' });

    try {
      const accounts = await web3.eth.getAccounts();
      await factory.createOrder(
          new Date().valueOf() / 20,
          this.state.name,
          this.state.city,
          this.state.quantity,
          this.state.receiver
        )

      Router.pushRoute('/');
    } catch (err) {
      this.setState({ errorMessage: err.message });
    }

    this.setState({ loading: false });
  };

  render() {
    return (
      <Layout>
        <h3>Create a Order</h3>

        <Form onSubmit={this.onSubmit} error={!!this.state.errorMessage}>
          <Form.Field>
            <label>Name</label>
            <Input
              // label="wei"
              // labelPosition="right"
              placeholder='Name'
              value={this.state.name}
              onChange={event =>
                this.setState({ name: event.target.value })}
            />
          </Form.Field>

          <Form.Field>
            <label>City</label>
            <Dropdown placeholder='City' search selection options={citiesMapped} onChange={(event, data) => {
                this.setState({ city: data.value })
                console.log(this.state, data.value)}}/>
          </Form.Field>
          <Form.Field>
            <label>Quantity (integer)</label>
            <Input
              // label="wei"
              // labelPosition="right"
              value={this.state.quantity}
              placeholder='Quantity'
              onChange={event =>
                this.setState({ quantity: parseInt(event.target.value) })}
            />
          </Form.Field>
          <Form.Field>
            <label>Receiver</label>
            <Input
              // label="wei"
              // labelPosition="right"
              value={this.state.receiver}
              placeholder='Receiver'
              onChange={event =>
                this.setState({ receiver: event.target.value })}
            />
          </Form.Field>
          <br/>
          <strong>Name: </strong>{ this.state.name }
          <br/>
          <strong>City: </strong>{ this.state.city }
          <br/>
          <strong>Quantity: </strong>{ this.state.quantity }
          <br/>
          <strong>Receiver: </strong>{ this.state.receiver }
          <br/><br/>
          <Message error header="Oops!" content={this.state.errorMessage} />
          <Button loading={this.state.loading} primary>
            Create Order!
          </Button>
        </Form>
      </Layout>
    );
  }
}

export default CampaignNew;
